def smart_binary_square(a):
	result = 0

	bits = [(a >> i) & 1 for i in range(32)]
	
	# Self product
	for i in range(32):
		result += bits[i] << (2*i)

	print(f"Self product is: {result}")

	# Cross product
	for i in range(32):
		for j in range(i+1, 32):
			result += ((bits[i] & bits[j]) << (i + j + 1))

	return result


a = int(input("Enter a number: "))
squared = smart_binary_square(a)
print(f"The square of {a} is {squared}")
