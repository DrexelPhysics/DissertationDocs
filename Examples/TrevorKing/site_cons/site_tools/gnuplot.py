import os.path
import re
import SCons.Action
import SCons.Scanner
import SCons.Script
import SCons.Util
import doctest

quoted_string_re = re.compile(r"'([^']*)'", re.M)

def gnuplot_scan(node, env, path, arg=None):
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
    >>> for p in gnuplot_scan(
    ...         node(os.path.join(src_dir, 'figures', 'order-dep', 'fig.gp')),
    ...         None, None, None):
    ...     print p
    data/order.avg-4
    data/order.avg-8
    data/order.avg-12
    data/order.avg-16
    data/hist3i.hist
    data/hist3ii.hist
    data/hist3iii.hist
    """
    try:
        contents = node.get_text_contents()
    except AttributeError:
        contents = node.get_contents() # for older versions of SCons, fall back on binary read
    ret = []
    for string in quoted_string_re.findall(contents):
        p = os.path.join(node.dir.srcnode().abspath, string)
        if len(string) > 0 and \
                ((string not in ret and os.path.exists(p))
                 or string.endswith('.dat')):
            ret.append(string)
    return ret

GnuplotAction = None

def generate(env):
    """Add Builders and construction variables for Gnuplot to an Environment."""
    global GnuplotAction
    if GnuplotAction is None:
        GnuplotAction = SCons.Action.Action('$GNUPLOTCOM', '$GNUPLOTCOMSTR')
    env['BUILDERS']['Gnuplot'] = SCons.Script.Builder(
        action=GnuplotAction, suffix='.pdf', src_suffix = '.gp')
    env['GNUPLOT'] = 'gnuplot'
    env['GNUPLOTFLAGS'] = '' #SCons.Util.CLVar('')
    env['GNUPLOTCOM'] = 'cd ${TARGET.dir} && $GNUPLOT $GNUPLOTFLAGS ${SOURCE.file}'
    env.Append(SCANNERS=SCons.Scanner.Base(
            function=gnuplot_scan,
            name='Gnuplot',
            skeys=['.gp']))

def exists(env):
    return env.Detect('gnuplot')

if __name__ == '__main__':
    doctest.testmod()
