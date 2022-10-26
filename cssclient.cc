#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <getopt.h>
#include "XrdPosix/XrdPosixXrootd.hh"
#include "XrdOuc/XrdOucString.hh"
#include "XrdCl/XrdClFile.hh"

XrdPosixXrootd posixXrootd;

#define BUFLEN 524288

int helpflg;
int debugflg;
int errflg;

void usage(const char *func)
{
	printf("usage: %s [option] <-f filename> <-c cssfunc> [-o outdir] -\n", func);
	printf("\toption\n\t-v or -V shows VERSION\n");
	printf("\t-d or --debug shows detailed information\n");
    	printf("For example: %s -f /eos/user/chyd/data.txt -c sort\n", func);
    	printf("Currently cssfunc support: sort, cat, zstd\n");
	char *mgmhost = getenv("EOS_MGM_URL");
	if (mgmhost == NULL) {
		printf("ERROR: Please set 'EOS_MGM_URL' like 'export EOS_MGM_URL=root://eosbak02.ihep.ac.cn//'\n");
	}	
}

void printver()
{
    fprintf(stdout, "CSSCLIENT Version: %s\n", VERSION);
	fprintf(stdout, "\nDeveloped by CC-IHEP\n");
}



int main(int argc, char *argv[])
{
	static struct option longopts[] = {
        {"help", no_argument, &helpflg, 1},
        {"debug", no_argument, &debugflg, 1},
        {0, 0, 0, 0}
    };

	char *filename = NULL;
	char *serveruri = NULL;
	char *outdir = NULL;
	char buffer[BUFLEN];
	char url[1024];
	const char *cssfunc = "cat";
	uint32_t nbytes = 0;
	int c;
	
	while ((c = getopt_long(argc, argv, "Vvdhf:c:o:", longopts, NULL)) != EOF) {
        switch (c) {
        case 'h':
            helpflg = 1;
            break;
        case 'f':
            filename = optarg;
            break;
        case 'c':
            cssfunc = optarg;
			break;
		case 'o':
			outdir = optarg;
			break;
        case 'd':
            debugflg = 1;
            break;
		case 'v':
        case 'V':
            printver();
            exit(0);
        case '?':
            errflg++;
            break;
        default:
            break;
        }
    }
	if (argc < 2 || !filename)
		errflg ++;
    if (errflg || helpflg) {
		usage(argv[0]);
		exit(1);
	}
	
	serveruri = getenv("EOS_MGM_URL");
	if (serveruri == NULL) {
		printf("'EOS_MGM_URL' not defined\n");
		exit(-1);
	} 
	
	sprintf(url, "%s%s?css=%s", serveruri, filename, cssfunc);
	if (outdir) {
		sprintf(url, "%s&css.outdir=%s", url, outdir);
	}
	//url += "?css=";
	//url += cssfunc;
	if (debugflg) 
		printf("Open file: %s\n", url);

	int fd =  XrdPosixXrootd::Open(url, O_RDONLY, 0);
    if (fd < 0) {
        printf("open file '%s' error %d %s\n", url, errno, strerror(errno));
        exit(-1);
    }

	bzero(buffer, BUFLEN);
	if ((strcmp("cat", cssfunc) == 0) || (strcmp("sort", cssfunc) == 0)) {
   		 while ((nbytes = XrdPosixXrootd::Read (fd, buffer, BUFLEN)) > 0) {
			printf("%s", buffer);
        	bzero(buffer, BUFLEN);
    	}
	}
	if (strcmp("zstd", cssfunc) == 0) {
		if (outdir) {
			char *fn = basename(filename);
			printf("file '%s/%s.zst' created\n", outdir, fn);
		} else
			printf("file '%s.zst' created\n", filename);
	}
	XrdPosixXrootd::Close(fd);
	return 0;
}
