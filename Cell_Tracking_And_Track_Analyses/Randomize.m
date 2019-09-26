function Z=Randomize(X)
Ntimes=size(X,2);
Ncells=size(X,1);
U=randi(Ntimes,Ncells,1);
Z=X;
for i=1:Ncells
    indices=mod(U(i):U(i)+Ntimes-1,Ntimes)+1;
    Z(i,:)=X(i,indices);
end
