# SMPL - Simple Parallel Language

Ajay S S Reddy Challa, Andrei Papancea, Devashi Tandon
{ac3647, alp2200, dt2450} @columbia.edu

December 20, 2013

Here is a brief overview:

#Tutorial
#2.1 A “Simple” Example

Here is a quick “Hello world!” program in SMPL:

int main(){
    printf(“Hello world!\n”);
}

Notice anything? Yes, SMPL uses the same syntax as C. Another thing that you should notice is
that there is no need to include anything. All the includes, given the features of the language are
added for you for convenience.
Let’s spice things up a bit, and write a more exciting “Hello world!” program:

say(string str){
    printf(“%s\n”,str);
}

int main(){
    spawn say(“Hello”);
    spawn say(“world”);
    spawn say(“user!”);
    barrier;
    printf(“Done!\n”);
}

The program above prints the strings “Hello”, “world”, “user!” in an undetermined order,
followed by the string “Done!”. What spawn does is creates a new thread for the given function
call. Hence, the function say gets called three times in three different threads, but it is not
possible to predict which of the three threads will finish first. The barrier statement prevents
“Done!” from beings printed before all the other threads have finished executing.
A few last things to notice before we move on are: void type is optional for function
definitions, which is why the say function does not have a type, and string is a type that does
not exist in C, so we implemented it in SMPL for simplicity — see what we did there?

# 2.2 Compiling and Running SMPL Programs
First, SMPL programs use .smpl as an extension, by convention. You have multiple options of
interacting with the compiler (smplc) by using the following command line arguments:

Argument Description
-a [-t | filename] print the parse results (AST) of the input SMPL code
-c [-t | filename] generate the C code equivalent to the input SMPL code
-s [-t | filename] perform syntax check of the input SMPL code

In the table above -t tells the compiler to take input from the terminal and filename tells the
compiler to compile the given file. The flags -a, -c, and -s must be followed by either -t or a
filename. The SMPL compiler will output C code.
For a more concrete example, open your favorite text editor, paste any of the two “Hello world”
programs above into the new file and save it as hello.smpl. Open the command line and run
./smplc -c hello.smpl > hello.c. What “> hello.c” does is it redirects the
output of the compiler to a file, rather than printing it in the terminal window.
Finally, to finish the compilation of your “Hello world” program run gcc -pthread
hello.c. Note that trying to compile the program without the -pthread flag will fail,
because the C output of SMPL uses the Posix Threads library to run programs in parallel.

# 2.3 “THE” Example
Here is a quick introduction to the four keywords that SMPL uses to perform parallelism:
1. spawn: tells the compiler that the function that spawn precedes should run in parallel
with the caller thread.
2. barrier: causes all previously spawn-ed threads to wait for each other to complete
before the program can continue
3. lock: synchronization mechanism that prevents multiple threads from changing a
variable concurrently
4. pfor: a for loop whose work is divided amongst a specified number of threads

Now let’s take a look at one more example. The SMPL program below computes the sum of all
the prime numbers up to one million.

int sum = 0;
int isPrime(int n){
  int limit = n/2;
  int i = 0;
  for(i=2; i<=limit; i++)
     if(n%i == 0)
       return 0;
  return 1;
}

int main(){
   int i;
   int n = 1000000;
   pfor(8; i; 1; n){
     if(isPrime(i))
     sum = sum+i;
   }
   printf("The sum of the first 1M primes is %d.\n",sum);
}
Here’s what you need to know about the code above:
1. it has the same length as the equivalent C code (in terms of functionality, not
performance)
2. it uses only one SMPL keyword
3. the SMPL program completed in 27.173 seconds.
4. the equivalent C program completed in 1 minute and 11.340 seconds.
Both programs ran on the CLIC machines using the same compiler and includes. In conclusion,
with very limited effort you can turn a serial C program into a parallel one. In this case, the
SMPL program ran more than twice as fast than its C counterpart.

# References: http://www.cs.columbia.edu/~sedwards/classes/2013/w4115-fall/reports/SMPL.pdf

PS: You can find the complete project details with slides and report at the link:
http://www.cs.columbia.edu/~sedwards/classes/2013/w4115-fall/index.html
Just look for SMPL on that web-page.
