#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include <winternl.h>
#pragma comment(lib, "ntdll.lib")

EXTERN_C
NTSTATUS
NTAPI
NtAllocateVirtualMemory(
    HANDLE ProcessHandle,
    PVOID* BaseAddress,
    ULONG_PTR ZeroBits,
    PSIZE_T RegionSize,
    ULONG AllocationType,
    ULONG Protect);


PVOID g_ReservedMemory = NULL;

static int LoadBotImpl()
{
    struct bypass_load_data {
        void* bot_module;
        char bot_directory[MAX_PATH];
        char bot_user[40];

        // same as GetAsyncKeyState
        void* fn_get_key_state;

        // should return TRUE if calling successfully
        // bool __fastcall IssueOrder(void* this_, int order, void* pos, void* target, int isAttackMove, int isPetMove, int unknown0)
        void* fn_issue_order;

        // should return TRUE if calling successfully
        // bool __fastcall SendSpellCastPacket(void* this_, void* spellDataClient)
        void* fn_cast_spell;

        // should return TRUE if calling successfully
        // bool __fastcall UpdateChargedSpell(void* this_, void* spellInst, int slot, void* pos, int bForceStop)
        void* fn_update_spell;

        bool use_configer;               // the internal easy configer (F2)
        bool use_inlinehook;             // use inline hook instead of vtable hook
        bool reserved_0[6];

        void* reserved_1;
        void* reserved_2;
        void* reserved_3;
        void* reserved_4;
        
        void *fn_bypass_register_memory; // anti signature scan
        void *fn_bypass_anti_crc;        // anti crc check
        void* fn_install_inline_hook;    // this is used to install inline hook if set, and [fn_bypass_anti_crc] will be skipped

        void* reserved_10[16];
    } request = {};

    // free the reserved memory and let core take it.
    if (g_ReservedMemory) 
    {
        VirtualFree(g_ReservedMemory, 0, MEM_RELEASE);
        g_ReservedMemory = NULL;
    }

    auto hBotModule = LoadLibraryA("C:\\hanbot\\league of legends\\core_cn.dll");  // the core.dll
    if (!hBotModule)
        return -1;

    request.bot_module = hBotModule;
    strcpy_s(request.bot_directory, ("C:\\hanbot\\league of legends\\"));  // the directory ends with "\"
    strcpy_s(request.bot_user, ("EE0BDF0F9CE165532696B5789968D1A6"));
    request.use_configer = true;

    // for bypass usings if you want to overwrite any of these:
    // request.fn_get_key_state = &BotImpl::GetAsyncKeyState;
    // request.fn_issue_order = &BotImpl::IssueOrder;
    // request.fn_cast_spell = &BotImpl::SendSpellCastPacket;
    // request.fn_update_spell = &BotImpl::UpdateChargedSpell;
    
    // bypass callbacks
    // request.fn_bypass_register_memory = +[](void* base, size_t size) {};
    // request.fn_bypass_anti_crc = +[](void* base, size_t size) {};

    // use inline hook
    // request.use_inlinehook = true;
    // request.fn_install_hook = +[](void** pp_function, void* p_detour) -> bool {};


    auto fn_setup = GetProcAddress(hBotModule, "setup");
    if (!fn_setup)
        return -2;

    reinterpret_cast<int(_cdecl*)(PVOID, DWORD_PTR, DWORD_PTR, DWORD_PTR)>(fn_setup)(&request, 0, 0, 0);

    return 0;
}

static DWORD WINAPI LoadBotRoutine(PVOID)
{
    int status = LoadBotImpl();
    if (status != 0) 
    {
        char err[255] = {0};
        sprintf_s(err, "err: %d", status);
        MessageBoxA(0, err, 0, 0);
        __fastfail(0);
    }

    return 0;
}

static void Initialize()
{
    SIZE_T RegionSize = 400 * 1024 * 1024;                                                                                      // at least 100MB, 200-400 is recommanded
    NtAllocateVirtualMemory(GetCurrentProcess(), &g_ReservedMemory, 1, &RegionSize, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);  // reserve memory
    if (!g_ReservedMemory) 
    {
        // error and exit, your bypass should be injected as soon as possible to reserve the memory
        __fastfail(0);
    }
}


BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{

    if (ul_reason_for_call == DLL_PROCESS_ATTACH) 
    {
        // the initialization routine when your bypass loaded
        Initialize();

        // And when ready, load core.dll, create a new thread to load (or do in game main thread)
        HANDLE hThread = CreateThread(NULL, 0, LoadBotRoutine, NULL, 0, NULL);
        if (hThread)
            CloseHandle(hThread);
        
    }

    return TRUE;
}

