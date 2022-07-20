def test(name):
    def test_in():
        print(name)
    return test_in

func = test('whyz')
func()

import time
def showtime(func):
    def wrapper():
        start_time = time.time()
        func()
        end_time = time.time()
        print('spend is {}'.format(end_time - start_time))
    return wrapper

foo = showtime(foo)

def foo():
    print('foo..')
    time.sleep(3)

foo = showtime(foo)
foo()


