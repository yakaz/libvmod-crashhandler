#include <stdlib.h>
#include <signal.h>

#include "vrt.h"
#include "bin/varnishd/cache.h"

#include "vcc_if.h"

void
vmod_hello_sighandler(int i){
		VAS_Fail(__func__, __FILE__, __LINE__, "You asked for it", errno, 0);

}
int
init_function(struct vmod_priv *priv, const struct VCL_conf *conf)
{
	signal(11,vmod_hello_sighandler);
	return (0);
}

const char *
vmod_hello(struct sess *sp, const char *name)
{
	char *p;
	unsigned u, v;
	raise(11);
	return (NULL);
}
