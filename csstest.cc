#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <TFile.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
	char buf[300];
	//const char* serveruri="root://eosbak02.ihep.ac.cn///eos/rep/";
	const char* serveruri="root://eosbak02.ihep.ac.cn///eos/user/chyd/";
	const char *filename = "hosts";
	const char *cssfunc = "sort";
	size_t	fsize;
	if ((argc > 1) && (!strcmp(argv[1], "-h") || !strcmp(argv[1], "--help"))) {
		printf("usage: %s [filename] [cssfunc]\n", argv[0]);
		exit(1);
	}
	if (argc >= 2) {
		 filename = argv[1];
	}
	if (argc >= 3) {
		cssfunc = argv[2];
	}

	std::string url=serveruri;
	url += filename;
	url += "?filetype=raw&css=";
	url += cssfunc;
	printf("open file: %s\n", url.c_str());
	TFile *f=TFile::Open(url.c_str());
	if (!f) {
		printf("open file failed %d\n", errno);
		return -1;
	}
	fsize = f->GetSize();
	if (fsize > 300)
		fsize = 300;
	f->ReadBuffer(buf, 0, fsize);
	f->Close();
	buf[fsize]=0;
	printf("%s \nlen=%d\n", buf, strlen(buf));
}
