import os.path
import re
import SCons.Action
import SCons.Scanner
import SCons.Script
import SCons.Util
import doctest


load_re = re.compile(r"^load (.*)")


def pymol_scan(node, env, path, arg=None):
    """
    >>> this_dir = os.path.dirname(__file__)
    >>> src_dir = os.path.join(this_dir, '..', '..', 'src')
    >>> class node (object):
    ...     def __init__(self, path):
    ...         self.path = path
    ...         self.abspath = os.path.abspath(self.path)
    ...         if os.path.isfile(self.path):
    ...             self.dir = node(os.path.dirname(path))
    ...     def get_text_contents(self):
    ...         return open(self.path, 'r').read()
    ...     def get_contents(self):
    ...         return self.get_text_contents()
    ...     def srcnode(self):
    ...         return self
    >>> for p in pymol_scan(
    ...         node(os.path.join(src_dir, 'figures', 'i27', '1TIT.pml')),
    ...         None, None, None):
    ...     print p
    1TIT.pdb
    """
    try:
        contents = node.get_text_contents()
    except AttributeError:
        contents = node.get_contents() # for older versions of SCons, fall back on binary read
    ret = []
    for string in load_re.findall(contents):
        p = os.path.join(node.dir.srcnode().abspath, string)
        if len(string) > 0 and (string not in ret and os.path.exists(p)):
            ret.append(string)
    return ret


PymolAction = None

def generate(env):
    """Add Builders and construction variables for Pymol to an Environment."""
    global PymolAction
    if PymolAction is None:
        PymolAction = SCons.Action.Action(
            '$PYMOLCOM', '$PYMOLCOMSTR')

    env['BUILDERS']['Pymol'] = SCons.Script.Builder(
        action=PymolAction, suffix='.png', src_suffix = '.pml')
    env['PYMOL'] = 'pymol'
    env['PYMOLFLAGS'] = '-cq'
    env['PYMOLCOM'] = 'cd ${TARGET.dir} && $PYMOL $PYMOLFLAGS ${SOURCE.file}'
    env.Append(SCANNERS=SCons.Scanner.Base(
            function=pymol_scan,
            name='pymol',
            skeys=['.pml']))

def exists(env):
    return env.Detect('pymol')

if __name__ == '__main__':
    doctest.testmod()
