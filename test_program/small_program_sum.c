int tab[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

int main() {
	int sum = 0;
	int * ptr;
	for (ptr = tab; ptr < &tab[10]; ptr++) {
		sum = sum + (*ptr);
	}
	return sum;
}
