import time

from features.desktop.utils import spawn

def umbriel_start():
    pass

def noctalia_start():
    time.sleep(1.5)
    spawn(["spotify"])
    spawn(["vesktop"])

def noctalia_logout():
    pass

def noctalia_reboot():
    pass

def noctalia_shutdown():
    pass
