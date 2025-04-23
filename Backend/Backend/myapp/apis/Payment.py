import datetime
from .. import models as md
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated,AllowAny
from rest_framework.response import Response


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def addTransaction(request):
    senderId = request.data.get('senderId')
    packageId = request.data.get('packageId')
    amount = request.data.get('amount')
    
    user = md.User.objects.get(id = senderId)
    package = md.Packages.objects.get(id = packageId)
    listing = md.Listing.objects.get(id = package.listingId)
    if listing.ownerID:
        owner = md.BusinessOwner.objects.get(id = listing.ownerID)
        md.Transaction(sender = user, receiverb = owner, amount = amount, package = package,status='Pending').save()
    
    else:
        owner = md.Freelancer.objects.get(id = listing.freelancerID)
        md.Transaction(sender = user, receiverf = owner, amount = amount, package = package,status='Pending').save()
    return Response({'status':'success'})




@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getWalletBalance(request,id,type):
    userID = md.User.objects.get(id=id)
    if type == 'freelancer':
        Freelancer = md.BankDetails.objects.filter(userID=userID)
        return Response({'status':'success','balance':Freelancer.balance})
    else:
        BusinessOwner = md.BankDetails.objects.filter(userID=userID)
        return Response({'status':'success','balance':BusinessOwner.balance})
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def WithdrawBalance(request):
    amount = request.data.get('amount')
    userID = request.data.get('userID')
    type = request.data.get('type')
    userID = md.User.objects.get(id=userID)
    bankDetails = request.data.get('bankDetails') 
    if type == 'freelancer':
        Freelancer = md.Freelancer.objects.get(userID=userID)
        Freelancer.balance = Freelancer.balance - amount
        Freelancer.save(update_fields=['balance'])
        md.BusinessTransaction(type="Withdraw",amount=amount,ownerf=Freelancer,date=datetime.datetime.now(),info=f"Withdrawal to {bankDetails}").save()
    else:
        BusinessOwner = md.BusinessOwner.objects.get(userID=userID)
        BusinessOwner.balance = BusinessOwner.balance - amount
        BusinessOwner.save(update_fields=['balance'])
        md.BusinessTransaction(type="Withdraw",amount=amount,ownerb=BusinessOwner,date=datetime.datetime.now(),info=f"Withdrawal to {bankDetails}").save()
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getTransactions(request,id,type):
    userID = md.User.objects.get(id=id)
    if type == 'freelancer':
        transactions = md.BusinessTransaction.objects.filter(ownerf=userID,status='Completed')
    else:
        transactions = md.BusinessTransaction.objects.filter(ownerb=userID,status='Completed')

    transactionSerializer = s.BusinessTransactionSerializer(transactions,many=True)
    return Response({'status':'success','data':transactionSerializer.data})    

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def approveBooking(request):
    bookingId = request.data.get('bookingId')
    transactionId = request.data.get('transactionId')
    transaction = md.Transaction.objects.get(id=transactionId)
    transaction.status = 'Completed'
    transaction.save(update_fields=['status'])
    # md.Orders(userId=,package=bookingId=bookingId,transactionId=transactionId).save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def rejectBooking(request):
    pass

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getBookings(request):
    pass


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getPendingBookings(request):
    pass



@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getTransactionsRecent(request,id,type):
    userID = md.User.objects.get(id=id)
    now = datetime.datetime.now()
    if type == 'freelancer':
        transactions = md.BusinessTransaction.objects.filter(ownerf=userID,date__year=now.year,
    date__month=now.month,status='Completed')
    else:
        transactions = md.BusinessTransaction.objects.filter(ownerb=userID,date__year=now.year,
    date__month=now.month,status='Completed')

    transactionSerializer = s.BusinessTransactionSerializer(transactions,many=True)
    return Response({'status':'success','data':transactionSerializer.data})    


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def addBank(request):
    bankName = request.data.get('bankName')
    accountNumber = request.data.get('accountNumber')
    IBANNumber = request.data.get('IBANNumber')
    accountHolderName = request.data.get('accountHolderName')
    userID = request.data.get('userID')
    userID = md.User.objects.get(id=userID)
    md.BankDetails(userID=userID,bankName=bankName,accountNumber=accountNumber,IBANNumber=IBANNumber,accountHolderName=accountHolderName).save()
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getBank(request,id):
    userID = md.User.objects.get(id=id)
    bank = md.BankDetails.objects.filter(userID=userID)
    bankSerializer = s.BankDetailsSerializer(bank,many=True)
    return Response({'status':'success','data':bankSerializer.data})

