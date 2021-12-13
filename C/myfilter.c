#include<stdio.h>
#include<stdlib.h>

#define NT 9 /// number of coeffs
#define NB 14 /// number of bits

const int b[NT]={-51,-112,419,2179,3323,2176,419,-112,-51}; /// b array

/// Perform fixed point filtering assming direct form I
///\param x is the new input sample
///\return the new output sample
int myfilter(int x)
{
  static int sx[NT]; /// x shift register
  static int first_run = 0; /// for cleaning shift registers
  int i; /// index
  int y; /// output sample

  /// clean the buffers
  if (first_run == 0)
  {
    first_run = 1;
    for (i=0; i<NT; i++)
      sx[i] = 0;
  }

  /// shift and insert new sample in x shift register
  for (i=NT-1; i>0; i--){
        sx[i] = sx[i-1];
  }
        sx[0] = x;
  /// make the convolution
  /// Moving average part
  y = 0;

  for (i=0; i<NT; i++){
    y += (sx[i]*b[i]) >> (NB-1);
//        printf("filter calculation sx: %d \t b: %d  y: %d \n",sx[i],b[i], y);
  }


  return y;
}

int main ()
{
  FILE *fp_in;
  FILE *fp_out;
  
  int x;
  int y;
  char* argv[3] = {"0", "samples.txt", "outputc.txt"};
  /// check the command line

  /// open files
  fp_in = fopen(argv[1], "r");
  if (fp_in == NULL)
  {
    printf("Error: cannot open %s\n");
    exit(2);
  }

  fp_out = fopen(argv[2], "w");

  /// get samples and apply filter
  fscanf(fp_in, "%d", &x);

  do{
    y = myfilter(x);
    fprintf(fp_out,"%d\n", y);
    fscanf(fp_in, "%d", &x);

  } while (!feof(fp_in));

  fclose(fp_in);
  fclose(fp_out);

  return 0;

}




