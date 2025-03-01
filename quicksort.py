//edit


def partition(A,p,r):
 #varsaydım ki pivot en sondaki eleman
    i=p-1

    for j in range (p,r):
        if(A[j]<=A[r]):
            i+=1
            temp = A[j]
            A[j]=A[i]
            A[i]=temp
            
    i+=1
    temp = A[r]
    A[r]=A[i]
    A[i]=temp

    return i    


def quicksort(A,p,r):
    if(p<r) :
        q = partition(A,p,r)
        quicksort(A,p,q-1)
        quicksort(A,q+1,r)


listem = [5,3,1,2,4,7,8,9,6]
print(f"ilk liste durumum: {listem}")
quicksort(listem,0,len(listem)-1)        
print(f"son liste durumum: {listem}")        
