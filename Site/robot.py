a = int(input("A: "))
b = int(input("A: "))
c = int(input("A: "))
d = int(input("B: "))
e = int(input("B: "))
f = int(input("B: "))
kp = 0.8
kd = 0.5
soma1 = a+b+c
soma2 = d+e+f
print(kp*(soma1 - soma2)+kd*(soma1 - soma2))
