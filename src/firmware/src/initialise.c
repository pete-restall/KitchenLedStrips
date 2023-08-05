#include "event.h"
#include "initialise.h"

static void initialisePins(void);

void initialise(void)
{
	initialisePins();
	eventInitialise();
	eventPublish(SYSTEM_INITIALISED, &eventEmptyArgs);
}

static void initialisePins(void)
{
}
