#!/usr/local/bin/python

import re
import subprocess
import sys

class States:
    Init, Entry, Middle, Return = range(4)

dscript = """
fbt::set_regs:entry
{
    self->td = args[0];
    printf("entry:\\n");
    print(*self->td->td_frame);
    printf("\\n");
}

fbt::set_regs:return
{
    printf("return:\\n");
    print(*self->td->td_frame);
    printf("\\n");
}
"""

tracer = subprocess.Popen(['stdbuf', '-o', 'L', 'dtrace', '-q', '-n', dscript],
                          close_fds=True, stdout=subprocess.PIPE)
reg_re = re.compile('\s+.* (\w+) = (\w+)')

state = States.Init
while True:
    line = tracer.stdout.readline()
    if line == '':
        break
    line = line.rstrip()
    if line == 'entry:':
        assert state == States.Init
        state = States.Entry
        before = {}
        regs = before
    elif line == 'return:':
        assert state == States.Middle
        state = States.Return
        after = {}
        regs = after
    elif line == 'struct trapframe {':
        assert len(regs) == 0
    elif line == '}':
        if state == States.Entry:
            state = States.Middle
        else:
            assert state == States.Return
            assert len(before) == len(after)
            print "set_regs() changes:"
            for reg in before.keys():
                assert reg in after
                if before[reg] == after[reg]:
                    continue
                print "    %s: %s => %s" % (reg, before[reg], after[reg])
            state = States.Init
    else:
        m = reg_re.match(line)
        if m == None:
            print "Invalid line: %s" % (line)
            sys.exit(1)
        if m.group(1) in regs:
            print "Duplicate register: %s" % (m.group[1])
            sys.exit(1)
        regs[m.group(1)] = m.group(2)
