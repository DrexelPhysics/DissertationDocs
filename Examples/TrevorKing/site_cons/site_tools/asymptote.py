import os.path
import re
import SCons.Action
import SCons.Scanner
import SCons.Script
import SCons.Util
import doctest


double_quoted_string_re = re.compile(r'"([^"]*)"', re.M)

# SCons' LaTeX scanner doesn't understand \asyinclude{}, so keep track
# of all Asymptote graphics for phony target creation.
asyfigs = []

def asymptote_scan(node, env, path, arg=None):
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
    >>> for p in asymptote_scan(
    ...         node(os.path.join(src_dir, 'figures', 'cantilever-sim', 'v-dep.asy')),
    ...         None, None, None):
    ...     print p
    v-dep.d/v_dep_127_8
    v-dep.d/v_dep_27_8
    v-dep.d/v_dep_127_30
    v-dep.d/v_dep_27_30
    v-dep.d/v_dep_0.1_1
    v-dep.d/v_dep_0.1_30
    v-dep.d/v_dep_127_8.fit.dat
    v-dep.d/v_dep_27_8.fit.dat
    v-dep.d/v_dep_127_30.fit.dat
    v-dep.d/v_dep_27_30.fit.dat
    v-dep.d/v_dep_0.1_1.fit.dat
    v-dep.d/v_dep_0.1_30.fit.dat
    """
    try:
        contents = node.get_text_contents()
    except AttributeError:
        contents = node.get_contents() # for older versions of SCons, fall back on binary read
    ret = []
    for string in double_quoted_string_re.findall(contents):
        if string in ret:
            continue # we've already added this dependency
        if len(string) == 0:
            continue # empty string not much of a dependency ;)
        p = os.path.join(node.dir.srcnode().abspath, string)
        if os.path.exists(p) and os.path.isfile(p): # probably an include file
            ret.append(string)
        elif string.endswith('.dat'): # marker for auto-generated include files
            ret.append(string)
    return ret

def asymptote_emitter(target, source, env):
    assert str(source[0]).endswith('.asy'), str(source[0])
    filebase = str(source[0])[:-len('.asy')]
    target.extend(['%s%s' % (filebase, ext)
                   for ext in ['.tex', '.pre', '_0.pdf']])
    source.append(SCons.Script.Alias('asytools'))
    # side effect, keep track of all asymptote graphics.
    asyfigs.append(target[0])
    return target, source

AsymptoteAction = None

def generate(env):
    """Add Builders and construction variables for Asymptote to an Environment."""
    global AsymptoteAction
    if AsymptoteAction is None:
        AsymptoteAction = SCons.Action.Action('$ASYMPTOTECOM', '$ASYMPTOTECOMSTR')
    env['BUILDERS']['Asymptote'] = SCons.Script.Builder(
        action=AsymptoteAction, suffix='.tex', src_suffix = '.asy',
        emitter=asymptote_emitter)
    env['ASYMPTOTE'] = 'asy'
    env['ASYMPTOTEFLAGS'] = SCons.Util.CLVar(
        '-tex pdflatex -inlineimage -inlinetex')
    env['ASYMPTOTECOM']  = 'cd ${TARGET.dir}' ## && $ASYMPTOTE $ASYMPTOTEFLAGS ${SOURCE.filebase}'
    env.Append(SCANNERS=SCons.Scanner.Base(
            function=asymptote_scan,
            name='Asymptote',
            skeys=['.asy']))

def exists(env):
    return env.Detect('asymptote')

if __name__ == '__main__':
    doctest.testmod()
