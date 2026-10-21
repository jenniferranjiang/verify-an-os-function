/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosRules */
inline void NULL_PARAM_CHECK_1(void *p)
/*@ 
    Require emp
    Ensure p != 0
*/
{
    do {
        if (p == (0)) {
            // KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, __LINE__, #param);
            /*@ Inv Assert
                p == 0
            */
            while (1)
                ;
        }
    } while (0);
}
inline void NULL_PARAM_CHECK_2(void (*entry)(void *parameter))
/*@ 
    Require emp
    Ensure entry != 0
*/
{
    do {
        if (entry == (0)) {
            // KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, __LINE__, #param);
            /*@ Inv Assert
                entry == 0
            */
            while (1)
                ;
        }
    } while (0);
}
