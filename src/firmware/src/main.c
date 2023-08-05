#include <stdbool.h>

#include "event.h"
#include "initialise.h"
#include "poll.h"

void main(void)
{
	initialise();
	while (true)
		poll();
}
