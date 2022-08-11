#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    node *tortoise = head, *hare = head;
    while (hare != NULL) {
        if (hare->next != NULL) 
            hare = hare->next;
        else break;

        if (hare->next != NULL) 
            hare = hare->next;
        else break;
        
        tortoise = tortoise->next;

        if (tortoise == hare) 
            return 1;
    }
    return 0;
}
