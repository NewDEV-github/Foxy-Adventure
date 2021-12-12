import requests
import os
import sys
import platform
from os import walk
import tkinter
from tkinter import messagebox

PY3 = sys.version_info[0] == 3

if PY3:
    unicode = str

if sys.platform.startswith('java'):
    import platform
    os_name = platform.java_ver()[3][0]
    if os_name.startswith('Windows'):
        system = 'win32'
    elif os_name.startswith('Mac'):
        system = 'darwin'
    else:
        system = 'linux2'
else:
    system = sys.platform



def user_data_dir(appname=None, appauthor=None, version=None, roaming=False):
    if system == "win32":
        if appauthor is None:
            appauthor = appname
        const = roaming and "CSIDL_APPDATA" or "CSIDL_LOCAL_APPDATA"
        path = os.path.normpath(_get_win_folder(const))
        if appname:
            if appauthor is not False:
                path = os.path.join(path, appauthor, appname)
            else:
                path = os.path.join(path, appname)
    elif system == 'darwin':
        path = os.path.expanduser('~/Library/Application Support/')
        if appname:
            path = os.path.join(path, appname)
    else:
        path = os.getenv('XDG_DATA_HOME', os.path.expanduser("~/.local/share"))
        if appname:
            path = os.path.join(path, appname)
    if appname and version:
        path = os.path.join(path, version)
    return path


def site_data_dir(appname=None, appauthor=None, version=None, multipath=False):
    if system == "win32":
        if appauthor is None:
            appauthor = appname
        path = os.path.normpath(_get_win_folder("CSIDL_COMMON_APPDATA"))
        if appname:
            if appauthor is not False:
                path = os.path.join(path, appauthor, appname)
            else:
                path = os.path.join(path, appname)
    elif system == 'darwin':
        path = os.path.expanduser('/Library/Application Support')
        if appname:
            path = os.path.join(path, appname)
    else:
        path = os.getenv('XDG_DATA_DIRS',
                         os.pathsep.join(['/usr/local/share', '/usr/share']))
        pathlist = [os.path.expanduser(x.rstrip(os.sep)) for x in path.split(os.pathsep)]
        if appname:
            if version:
                appname = os.path.join(appname, version)
            pathlist = [os.sep.join([x, appname]) for x in pathlist]

        if multipath:
            path = os.pathsep.join(pathlist)
        else:
            path = pathlist[0]
        return path

    if appname and version:
        path = os.path.join(path, version)
    return path


def user_config_dir(appname=None, appauthor=None, version=None, roaming=False):
    if system in ["win32", "darwin"]:
        path = user_data_dir(appname, appauthor, None, roaming)
    else:
        path = os.getenv('XDG_CONFIG_HOME', os.path.expanduser("~/.config"))
        if appname:
            path = os.path.join(path, appname)
    if appname and version:
        path = os.path.join(path, version)
    return path


def site_config_dir(appname=None, appauthor=None, version=None, multipath=False):
    if system in ["win32", "darwin"]:
        path = site_data_dir(appname, appauthor)
        if appname and version:
            path = os.path.join(path, version)
    else:
        path = os.getenv('XDG_CONFIG_DIRS', '/etc/xdg')
        pathlist = [os.path.expanduser(x.rstrip(os.sep)) for x in path.split(os.pathsep)]
        if appname:
            if version:
                appname = os.path.join(appname, version)
            pathlist = [os.sep.join([x, appname]) for x in pathlist]

        if multipath:
            path = os.pathsep.join(pathlist)
        else:
            path = pathlist[0]
    return path


def user_cache_dir(appname=None, appauthor=None, version=None, opinion=True):
    if system == "win32":
        if appauthor is None:
            appauthor = appname
        path = os.path.normpath(_get_win_folder("CSIDL_LOCAL_APPDATA"))
        if appname:
            if appauthor is not False:
                path = os.path.join(path, appauthor, appname)
            else:
                path = os.path.join(path, appname)
            if opinion:
                path = os.path.join(path, "Cache")
    elif system == 'darwin':
        path = os.path.expanduser('~/Library/Caches')
        if appname:
            path = os.path.join(path, appname)
    else:
        path = os.getenv('XDG_CACHE_HOME', os.path.expanduser('~/.cache'))
        if appname:
            path = os.path.join(path, appname)
    if appname and version:
        path = os.path.join(path, version)
    return path


def user_state_dir(appname=None, appauthor=None, version=None, roaming=False):
    if system in ["win32", "darwin"]:
        path = user_data_dir(appname, appauthor, None, roaming)
    else:
        path = os.getenv('XDG_STATE_HOME', os.path.expanduser("~/.local/state"))
        if appname:
            path = os.path.join(path, appname)
    if appname and version:
        path = os.path.join(path, version)
    return path


def user_log_dir(appname=None, appauthor=None, version=None, opinion=True):
    if system == "darwin":
        path = os.path.join(
            os.path.expanduser('~/Library/Logs'),
            appname)
    elif system == "win32":
        path = user_data_dir(appname, appauthor, version)
        version = False
        if opinion:
            path = os.path.join(path, "Logs")
    else:
        path = user_cache_dir(appname, appauthor, version)
        version = False
        if opinion:
            path = os.path.join(path, "log")
    if appname and version:
        path = os.path.join(path, version)
    return path


class AppDirs(object):
    def __init__(self, appname=None, appauthor=None, version=None,
            roaming=False, multipath=False):
        self.appname = appname
        self.appauthor = appauthor
        self.version = version
        self.roaming = roaming
        self.multipath = multipath

    @property
    def user_data_dir(self):
        return user_data_dir(self.appname, self.appauthor,
                             version=self.version, roaming=self.roaming)

    @property
    def site_data_dir(self):
        return site_data_dir(self.appname, self.appauthor,
                             version=self.version, multipath=self.multipath)

    @property
    def user_config_dir(self):
        return user_config_dir(self.appname, self.appauthor,
                               version=self.version, roaming=self.roaming)

    @property
    def site_config_dir(self):
        return site_config_dir(self.appname, self.appauthor,
                             version=self.version, multipath=self.multipath)

    @property
    def user_cache_dir(self):
        return user_cache_dir(self.appname, self.appauthor,
                              version=self.version)

    @property
    def user_state_dir(self):
        return user_state_dir(self.appname, self.appauthor,
                              version=self.version)

    @property
    def user_log_dir(self):
        return user_log_dir(self.appname, self.appauthor,
                            version=self.version)


def _get_win_folder_from_registry(csidl_name):
    if PY3:
      import winreg as _winreg
    else:
      import _winreg

    shell_folder_name = {
        "CSIDL_APPDATA": "AppData",
        "CSIDL_COMMON_APPDATA": "Common AppData",
        "CSIDL_LOCAL_APPDATA": "Local AppData",
    }[csidl_name]

    key = _winreg.OpenKey(
        _winreg.HKEY_CURRENT_USER,
        r"Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
    )
    dir, type = _winreg.QueryValueEx(key, shell_folder_name)
    return dir


def _get_win_folder_with_pywin32(csidl_name):
    from win32com.shell import shellcon, shell
    dir = shell.SHGetFolderPath(0, getattr(shellcon, csidl_name), 0, 0)
    try:
        dir = unicode(dir)
        has_high_char = False
        for c in dir:
            if ord(c) > 255:
                has_high_char = True
                break
        if has_high_char:
            try:
                import win32api
                dir = win32api.GetShortPathName(dir)
            except ImportError:
                pass
    except UnicodeError:
        pass
    return dir


def _get_win_folder_with_ctypes(csidl_name):
    import ctypes

    csidl_const = {
        "CSIDL_APPDATA": 26,
        "CSIDL_COMMON_APPDATA": 35,
        "CSIDL_LOCAL_APPDATA": 28,
    }[csidl_name]

    buf = ctypes.create_unicode_buffer(1024)
    ctypes.windll.shell32.SHGetFolderPathW(None, csidl_const, None, 0, buf)
    has_high_char = False
    for c in buf:
        if ord(c) > 255:
            has_high_char = True
            break
    if has_high_char:
        buf2 = ctypes.create_unicode_buffer(1024)
        if ctypes.windll.kernel32.GetShortPathNameW(buf.value, buf2, 1024):
            buf = buf2

    return buf.value

def _get_win_folder_with_jna(csidl_name):
    import array
    from com.sun import jna
    from com.sun.jna.platform import win32

    buf_size = win32.WinDef.MAX_PATH * 2
    buf = array.zeros('c', buf_size)
    shell = win32.Shell32.INSTANCE
    shell.SHGetFolderPath(None, getattr(win32.ShlObj, csidl_name), None, win32.ShlObj.SHGFP_TYPE_CURRENT, buf)
    dir = jna.Native.toString(buf.tostring()).rstrip("\0")
    has_high_char = False
    for c in dir:
        if ord(c) > 255:
            has_high_char = True
            break
    if has_high_char:
        buf = array.zeros('c', buf_size)
        kernel = win32.Kernel32.INSTANCE
        if kernel.GetShortPathName(dir, buf, buf_size):
            dir = jna.Native.toString(buf.tostring()).rstrip("\0")

    return dir

if system == "win32":
    try:
        import win32com.shell
        _get_win_folder = _get_win_folder_with_pywin32
    except ImportError:
        try:
            from ctypes import windll
            _get_win_folder = _get_win_folder_with_ctypes
        except ImportError:
            try:
                import com.sun.jna
                _get_win_folder = _get_win_folder_with_jna
            except ImportError:
                _get_win_folder = _get_win_folder_from_registry


def cumpute_file_path():
    appauthor = "Godot"
    appname = "app_userdata"
    if platform.system() == 'Windows':
        file_path = user_data_dir(appname, appauthor, roaming=True)
    elif platform.system() == 'Darwin' or platform.system() == 'Linux':
        file_path = user_data_dir(appname, appauthor)
    file_path += '/Foxy Adventure/logs/'
    f = []
    for (dirpath, dirnames, filenames) in walk(file_path):
        f.extend(filenames)
        break
    file_path += f[1]
    return file_path
def prepare_log(file):
    f = open(file, "r")
    log_text = f.read()
    return log_text
def send_log(l_text):
    params = {'log_text': l_text, 'game': 'FoxyAdventure'}
    url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/logs/send-log/"
    r = requests.post(url, data=params)
    return r.text
if __name__ == '__main__':
    log_id = send_log(prepare_log(cumpute_file_path()))
    root = tkinter.Tk()
    root.withdraw()
    tkinter.messagebox.showinfo('Foxy Adventure Crash Report', 'Your log was sent!\n\nLog id is: '+ str(log_id) + '\n\nPlease include that log id while contacting developers for requesting a bug\nThank You :3')
