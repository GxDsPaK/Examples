
def main():
    choice=int(input("Press 1 to encrypt, press 2 to decrypt: "))

    #Encryption: Takes values of M, W, and A and sends to encryption function 
    if choice==1:
        m=int(input("Enter the value of M: "))
        w=int(input("Enter the value of W: "))
        a=[]
        S=input("Enter the super-increasing string A of length 8 with spaces between each number: ")
        s_list=S.split()
        for num in s_list:
            a.append(int(num))
        cipher=[]
        cipher=encrypt(m, w, a)
        print("Ciphertext is: ", cipher)


    #Decryption: Takes values of M, W, A and sends to the decryption function. Finds inverse automatically. 
    elif choice==2:
        m=int(input("Enter the value of M: "))
        w=int(input("Enter the value of W: "))
        winv=pow(w, m-2, m)
        print("The multiplicative inverse is: ", winv)
        a=[]
        S=input("Enter the super-increasing string A of length 8 with spaces between each number: ")
        s_list=S.split()
        for num in s_list:
            a.append(int(num))
        plain=[]    
        plain=decrypt(m, winv, a)
        if plain==False:
            print("No solutions found")
        else:
            print("Plaintext is: ", plain)
    
    else:
        (print("Not a valid input"))

    


def encrypt(m, w, a):
    #Creates the public key B using the formula given 
    b=[]
    for num in a:
        bnum=(num*w)%m
        b.append(bnum)
    print("public key is: ", b)

    #Takes user input and converts it to a list with 1 element in each index
    plain1=input("Enter the binary string plaintext of length 8, with space between the digits: ")
    p1=[]
    plain=plain1.split()
    for num in plain:
        p1.append(int(num))

    #Creates new ciphertext and performs calculation per each binary element. Takes results and adds them for totals sum called temp. Adds temp to final list and returns the list     
    cipher1=[]
    cipher=[]
    for i in range(len(p1)):
        cipher1.append(p1[i] * b[i])

    temp=0
    for element in cipher1:
        temp+=element
    
    cipher.append(temp)
    
    return cipher


def decrypt(m, winv, a):
    ciphernum=int(input("Enter the decimal value of the ciphertext: "))
    #Finds S
    s=(winv*ciphernum)%m
    print("S value is: ", s)
    plain=[]
    #Performs easy knapsack algorithm
    for element in reversed(a):
        if s>=element:
            plain.append("1")
            s=s-element
        else:
            plain.append("0")
    if s!=0:
        return False
    #Organizes resultant string into correct orientation then prints to empty string for better display 
    else:
        plain1=plain[::-1]
        plain2=''.join(map(str, plain1))
        return plain2

    

main()
