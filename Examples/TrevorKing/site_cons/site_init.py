import os.path
import SCons.Node.FS


def subdirs(env, *args, **kwargs):
    for subdir in env.fs.Glob(env.subst(args[0]), *args[1:], **kwargs):
        if isinstance(subdir, SCons.Node.FS.Dir):
            yield subdir

def include_child_SConscripts(env, SConscript, first=[]):
    """Get all the nested SConscripts in that may alter and pass back
    the environment.  They may also add thesis subdependencies to that
    environment.
    """
    sdirs = list(subdirs(env, '*'))
    for subdir in reversed(first): # move first subdirs to the front
        if subdir in sdirs:
            sdirs.remove(subdir)
            sdirs.insert(0, subdir)
    for subdir in sdirs:
        var_sconscript_path = os.path.join(subdir.abspath,
                                           'SConscript')
        src_sconscript_path = os.path.join(subdir.srcnode().abspath,
                                           'SConscript')
        if os.path.exists(src_sconscript_path):
            if env.GetOption('silent') is False:
                # ideally 'silent' should be -Q, not the current -s/--silent/--quiet
                print 'Including', var_sconscript_path
            env = SConscript(var_sconscript_path, 'env')
    return env

def check_exec(context, executible):
    # TODO: context.env vs. context.vardict
    context.Message('Checking for %s executible...' % executible)
    if executible.upper() in context.env:
        context.Result('yes')
        return 'yes'
    result = 'no'
    for p in context.env.Dictionary()['ENV']['PATH']:
        path = os.path.join(p, executible)
        if os.path.exists(path):
            result = 'yes'
            break
    context.Result(result)
    if result is 'yes':
        context.env[executible.upper()] = path
    return result

def _recursive_glob_dir(env, *args, **kwargs):
    assert len(args) > 0
    glob_results = env.fs.Glob(env.subst(args[0]), *args[1:], **kwargs)
    sds = list(subdirs(env, *(['*']+list(args[1:])), **kwargs))
    return (sds, glob_results)

def recursive_glob(env, *args, **kwargs):
    dir_stack = [kwargs.pop('cwd', None)]
    glob_results = []
    while len(dir_stack) > 0:
        kwargs['cwd'] = dir_stack.pop(0)
        subdirs,results = _recursive_glob_dir(env, *args, **kwargs)
        dir_stack.extend(subdirs)
        glob_results.extend(results)
    return glob_results

def link_wtk_graph(env):
    return env.Command('wtk_graph.asy', '../asy/wtk_graph.asy',
                       SCons.Script.Copy('$TARGET', '$SOURCE'))

def link_pyfit(env):
    return env.Command('pyfit', '../script/pyfit',
                       SCons.Script.Copy('$TARGET', '$SOURCE'))
