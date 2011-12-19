#include <stdlib.h>
#include <signal.h>

#include "vrt.h"
#include "bin/varnishd/cache.h"

#include "vcc_if.h"

void
vmod_ch_sighandler(int i){
		VAS_Fail(__func__,
			 __FILE__,
			 __LINE__,
			 "You asked for it",
			 errno,
			 0);
}

int
init_function(struct vmod_priv *priv, const struct VCL_conf *conf)
{
	signal(SIGSEGV,vmod_ch_sighandler);
	return (0);
}

void
vmod_crash(struct sess * sp)
{
	raise(SIGSEGV);
}
