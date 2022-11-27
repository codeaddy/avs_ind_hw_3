#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void read_string(char* str, int *n, FILE *ptr) {
	*n = fread(str, sizeof(char), 10, ptr);
}

void print_double(double res, FILE *ptr) {
	fprintf(ptr, "%0.8f", res);
}

void process(double* result, double x) {
	double current = 0, x_pow = x;
	*result = 0;
	for (int i = 0; ; i++) {
		current = x_pow / (2 * i + 1);
		x_pow *= -1 * x * x;
		*result += current;
		if (fabs(current) < 0.0005) {
			break;
		}
	}
}

void generate(double* x, double l_gr, double r_gr) {
	*x = l_gr + (rand() * 1.0 / RAND_MAX * (r_gr - l_gr));
}

int main(int argc, char* argv[]) {
	if (argc != 4) {
		puts("Command line doesn't fit pattern '{program_name} -d {input_file_name} {output_file_name}' ");
		puts("or\n'{program_name} -g {cycles_count} {output_file_name}\n'Program finished.");
		return 0;
	}

	srand(time(NULL));

	char *type;
	char *file_in, *file_out;

	type = argv[1];
	if ((strcmp(type, "-g") != 0 && strcmp(type, "-d") != 0)) {
		puts("Command line doesn't fit pattern '{program_name} -d {input_file_name} {output_file_name}' ");
		puts("or\n'{program_name} -g {cycles_count} {output_file_name}\n'Program finished.");
		return 0;
	}

	char str[10];
	int n = 0, cycles = 500000000;
	double x = 0;

	if (strcmp(type, "-d") == 0) {
		file_in = argv[2];
		file_out = argv[3];
		FILE *fin_ptr = fopen(file_in, "r");

		if (fin_ptr == NULL) {
			puts("Couldn't open input file.\nProgram finished.");
			return 0;
		}

		read_string(str, &n, fin_ptr);
		fclose(fin_ptr);
		x = atof(str);
	} else {
		cycles = atoi(argv[2]);
		file_out = argv[3];
		generate(&x, -1, 1);
	}

	double result = 0;

	clock_t t_start = clock();

	for (int cnt = 0; cnt < cycles; cnt++) {
		process(&result, x);
	}

	clock_t t_stop = clock();

	FILE *fout_ptr = fopen(file_out, "w");

	if (fout_ptr == NULL) {
		puts("Couldn't open output file.\nProgram finished.");
		return 0;
	}

	fprintf(fout_ptr, "input data:\n");
	print_double(x, fout_ptr);

	fprintf(fout_ptr, "\n\noutput data:\n");
	print_double(result, fout_ptr);

	printf("Spent time:%f sec.\n", (t_stop - t_start * 1.0) / CLOCKS_PER_SEC);
	fclose(fout_ptr);
	
	return 0;
}