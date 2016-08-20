#if defined(DEBUG)
extern void DGSSetupUIKitMainThreadGuard(void);
#else
inline void DGSSetupUIKitMainThreadGuard(void) {}
#endif
