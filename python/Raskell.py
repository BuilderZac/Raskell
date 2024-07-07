import random

loopCap = 255


def keyGen(length, seed):
    random.seed(seed)
    keyString = ""
    kk = False

    for i in range(length):
        if random.randrange(i, length) == i and not kk:
            keyString = keyString + "kk"
            kk = True
        else:
            keyString = keyString + "%0.2X" % random.randrange(0, 255)

    return keyString


def keyWrite():
    pass


def keyRead():
    pass


def keyTool():
    pass


def encrypt():
    pass


def decrypt():
    pass
