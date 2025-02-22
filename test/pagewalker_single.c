#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <assert.h>
#define PAGESIZE 4096
#define HUGEPAGESIZE 2097152
#define _page_off(base, pid) ((char*)(base) + PAGESIZE * pid)

#define PATTERN_N 4
typedef struct pattern{
  int size_order; //size of this write pattern 2^n
  int freq_order; //frequency of this write pattern 1/2^n the higher the less frequency
} walk_pattern;

walk_pattern patterns[PATTERN_N] = {
  {1, 1}, {1, 2}, {1, 3}, {1, 6} 
  // {
  //   .freq_order = 1 ;
  //   .size_ofder = 1 ;
  // },
  // {
  //   .freq_order = 2 ;
  //   .size_ofder = 1 ;
  // },
  // {
  //   .freq_order = 4 ;
  //   .size_ofder = 1 ;
  // },  
  // {
  //   .freq_order = 8 ;
  //   .size_ofder = 1 ;
  // },
};
char* bases[PATTERN_N];
int walk_pgnums[PATTERN_N], walk_freqs[PATTERN_N], walk_pgnum_tot = 0;
const int jump = 256;
static void access_random_pages(){
    int trigger = rand() % 100;
    if (trigger < 70) return; //posibility is 0.3
    int pat = rand() % PATTERN_N;
    int numpage = rand() % 32;
    int offset =rand()% ( walk_pgnums[pat] - numpage );
    for (int i = 0; i < numpage; i++){
    	for (int in = 0; in < PAGESIZE; in+=jump){
            *(_page_off(bases[pat], offset + i) + in) = (char)((offset + i + in)% 256);
    	}
    }
}
int main(int argc, char* argv[]){
    //struct timeval begin, end;
    struct timespec begin, end;
    srand(1234567);

    int walk_pagenum = 76800 , 
      s_interval = 0, l_interval = 2, round = 75, sleeptime = 0;
    //900 round ≈ 30min at l_interval = 2s

    if (argc > 1) walk_pagenum = atoi(argv[1]);//num of page to walk
    if (argc > 2) s_interval = atoi(argv[2]); //ms
    if (argc > 3) l_interval = atoi(argv[3]); //s
    if (argc > 4) round = atoi(argv[4]);    
    if (argc > 5) sleeptime = atoi(argv[5]);  //s
    
 //   int walk_pgnums[PATTERN_N], walk_freqs[PATTERN_N], walk_pgnum_tot = 0;
    for (int i = 0; i < PATTERN_N; i++){
      walk_pgnums[i] = pow(2, patterns[i].size_order);
      walk_freqs[i]  = pow(2, patterns[i].freq_order - 1);
      walk_pgnum_tot +=  walk_pgnums[i];
    }

    int last_pgnum = walk_pagenum;
    for (int i = 0; i < PATTERN_N-1; i++){
      printf("%d %d %d %d\n",  walk_pagenum, walk_pgnums[i], walk_pgnum_tot, last_pgnum);
      int pgnum = walk_pagenum * walk_pgnums[i] / walk_pgnum_tot;

      pgnum = ( pgnum / 512 ) * 512;
      last_pgnum -= pgnum;
      //we what pgwalk size to be THP alligned
      walk_pgnums[i] = pgnum;
    }
    walk_pgnums[3] = last_pgnum;

    printf("starting memory stress:\n");
    printf("	repetitive access on [%d] normal pages, spans [%dM] memory\n", 
		walk_pagenum, walk_pagenum * PAGESIZE / 1048576);
    for(int i = 0; i < PATTERN_N; i++){
      printf("  PATTERN[%d]: sizes [%d] pages, spans [%dM] memory, freq [%d]\n",i, 
      walk_pgnums[i], walk_pgnums[i] * PAGESIZE / 1048576, walk_freqs[i]); 
    }
    printf("	walk [%d] rounds, rounds interval [%d]ms, pagewalk interval [%d]ms\n", 
		round, l_interval * 1000, s_interval);

    //malloc
    //char* base = (char*)malloc(PAGESIZE * walk_pagenum);
    void* base;

//    posix_memalign(&base,HUGEPAGESIZE, PAGESIZE * walk_pagenum);
    
    posix_memalign(&base,PAGESIZE, PAGESIZE * walk_pagenum);
    //char* bases[PATTERN_N];
    bases[0] = (char*)base;
    for(int i = 1; i < PATTERN_N; i++){
      bases[i] = bases[i-1] + walk_pgnums[i-1] * PAGESIZE;
    }

    assert(bases[0] + (walk_pgnums[0] +  walk_pgnums[1] + walk_pgnums[2]) * PAGESIZE == bases[3]);
    sleep(10);
    /*
    for (int r = 0; r < 100; r++){
    	for (int p = 0; p < 4; p++){  //first two goes to high ; last two goes to end
      		for (int i = 0; i < walk_pgnums[p]; i++){
       			for (int in = 0; in < PAGESIZE; in+=jump){	
				*(_page_off(bases[p], i) + in) = (char)((i+in) % 256);
    			}
			//printf("%d %d\n", p, i);
		}
       		//if (p > 2) madvise(bases[p], walk_pgnums[p]*PAGESIZE, 27);
    	}
    }
    */
    
    //touch & add
    for (int r = 0; r < 2; r++){
    	for (int p = 0; p < PATTERN_N; p++){  //first two goes to high ; last two goes to end
      		for (int i = 0; i < walk_pgnums[p]; i++){
        		*_page_off(bases[p], i) = (char)(i % 256);
      		}
		if (p > 2) madvise(bases[p], walk_pgnums[p]*PAGESIZE, 28);
    	}
    }

    //warm up ok
    //
    //gettimeofday(&begin, 0);
    clock_gettime(CLOCK_REALTIME, &begin);
    for (int epoch = 0; epoch < round; epoch++){
	      printf("epoch %d \n", epoch);
        for(int pat = 0; pat < PATTERN_N; pat++){
          if (epoch % walk_freqs[pat]) continue;
	  //access_random_pages();
          for (int i = 0; i < walk_pgnums[pat]; i++){
              if (!(i % 8)) access_random_pages();
	      //if (rand()%100 < 10) continue;
	      for (int ext = 2; ext < 3; ext++){
	      	for (int in = 0; in < PAGESIZE; in+=jump){
               	  *(_page_off(bases[pat], i) + in) = (char)(((i + in)% 256) * ext % 256);
              	}
	      }
	      //usleep(s_interval*10); //sleep for s_interval ms
          } 
          if (pat > 2) madvise(bases[pat], walk_pgnums[pat]*PAGESIZE, 28);
        }
        //usleep(l_interval * 1000);
    }
    //sleep(sleeptime);
    //gettimeofday(&end, 0);
    clock_gettime(CLOCK_REALTIME, &end);
    long seconds = end.tv_sec - begin.tv_sec;
    long nanoseconds = end.tv_nsec - begin.tv_nsec;
    double elapsed = (double)seconds + (double)nanoseconds*1e-9;
    printf("Time measured: %.3f seconds.\n", elapsed);
    return 0;
}
