# ============================================================
# C Programming
# ============================================================

#include <stdatomic.h>
#include <sys/mman.h>
#include <execinfo.h>
#include <setjmp.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <ucontext.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <sys/epoll.h>

# ============================================================
# ARENA ALLOCATOR
# ============================================================

typedef struct Arena {
    char *buffer;
    size_t buffer_size;
    size_t offset;
} Arena;

void arena_init(Arena *arena, void *buffer, size_t size) {
    arena->buffer = buffer;
    arena->buffer_size = size;
    arena->offset = 0;
}

void *arena_alloc(Arena *arena, size_t size) {
    if (arena->offset + size > arena->buffer_size) return NULL;
    void *ptr = &arena->buffer[arena->offset];
    arena->offset += size;
    return ptr;
}

# ============================================================
# LOCK-FREE STACK
# ============================================================

typedef struct LFNode {
    void *data;
    struct LFNode *next;
} LFNode;

typedef struct LFStack {
    _Atomic LFNode *head;
} LFStack;

void lf_stack_push(LFStack *stack, void *data) {
    LFNode *new_node = malloc(sizeof(LFNode));
    new_node->data = data;
    LFNode *old_head;
    do {
        old_head = atomic_load(&stack->head);
        new_node->next = old_head;
    } while (!atomic_compare_exchange_weak(&stack->head, &old_head, new_node));
}

# ============================================================
# TYPE SYSTEM
# ============================================================

#define TYPE_ID(X) _Generic((X), \
    int: 0, \
    double: 1, \
    char*: 2, \
    default: -1)

#define STATIC_ASSERT(cond, msg) _Static_assert(cond, msg)

# ============================================================
# TYPE-PUNNING WITH UNIONS
# ============================================================

typedef union FloatInt {
    float f;
    uint32_t i;
    unsigned char bytes[4];
} FloatInt;

float fast_inverse_sqrt(float number) {
    FloatInt fi = { .f = number };
    fi.i = 0x5f3759df - (fi.i >> 1);
    fi.f = fi.f * (1.5f - (number * 0.5f * fi.f * fi.f));
    return fi.f;
}

# ============================================================
# SIGNAL HANDLING
# ============================================================

static volatile sig_atomic_t signal_received = 0;
static ucontext_t signal_context;

void signal_handler(int sig, siginfo_t *info, void *ucontext) {
    signal_received = sig;
    if (ucontext) {
        memcpy(&signal_context, ucontext, sizeof(ucontext_t));
    }
    write(STDERR_FILENO, "Signal received\n", 16);
}

# ============================================================
# COROUTINES WITH SETJMP/LONGJMP
# ============================================================

typedef struct Coroutine {
    jmp_buf context;
    void *stack;
    size_t stack_size;
    int state;
} Coroutine;

#define COROUTINE_START(coro) \
    if (setjmp((coro)->context) == 0) { \
    } else { \
    }

#define COROUTINE_YIELD(coro) \
    if (setjmp((coro)->context) == 0) { \
        longjmp(main_context, 1); \
    }

# ============================================================
# OPTIMIZATION HELPERS
# ============================================================

#ifdef __GNUC__
#define ALIGNED(x) __attribute__((aligned(x)))
#define LIKELY(x) __builtin_expect(!!(x), 1)
#define UNLIKELY(x) __builtin_expect(!!(x), 0)
#endif

int binary_search(int *array, size_t size, int target) {
    size_t low = 0, high = size - 1;
    while (LIKELY(low <= high)) {
        size_t mid = low + (high - low) / 2;
        int mid_val = array[mid];
        if (UNLIKELY(mid_val == target)) return mid;
        if (mid_val < target) low = mid + 1;
        else high = mid - 1;
    }
    return -1;
}

# ============================================================
# BIT MANIPULATION
# ============================================================

typedef uint64_t Bitboard;
#define SET_BIT(bb, square) ((bb) |= (1ULL << (square)))

int popcount(uint64_t x) {
    x = (x & 0x5555555555555555) + ((x >> 1) & 0x5555555555555555);
    x = (x & 0x3333333333333333) + ((x >> 2) & 0x3333333333333333);
    x = (x & 0x0F0F0F0F0F0F0F0F) + ((x >> 4) & 0x0F0F0F0F0F0F0F0F);
    x = (x & 0x00FF00FF00FF00FF) + ((x >> 8) & 0x00FF00FF00FF00FF);
    x = (x & 0x0000FFFF0000FFFF) + ((x >> 16) & 0x0000FFFF0000FFFF);
    x = (x & 0x00000000FFFFFFFF) + ((x >> 32) & 0x00000000FFFFFFFF);
    return x;
}

# ============================================================
# DEBUGGING UTILITIES
# ============================================================

#define ASSERT_TRACE(condition) \
    do { \
        if (!(condition)) { \
            void *buffer[100]; \
            int frames = backtrace(buffer, 100); \
            char **symbols = backtrace_symbols(buffer, frames); \
            fprintf(stderr, "Assertion failed: %s (%s:%d)\n", #condition, __FILE__, __LINE__); \
            for (int i = 0; i < frames; i++) { \
                fprintf(stderr, "%s\n", symbols[i]); \
            } \
            free(symbols); \
            abort(); \
        } \
    } while(0)

# ============================================================
# MEMORY-MAPPED FILES
# ============================================================

void *mmap_file(const char *filename, size_t *size) {
    int fd = open(filename, O_RDONLY);
    if (fd == -1) return NULL;

    struct stat sb;
    if (fstat(fd, &sb) == -1) {
        close(fd);
        return NULL;
    }

    *size = sb.st_size;
    void *addr = mmap(NULL, *size, PROT_READ, MAP_PRIVATE, fd, 0);
    close(fd);
    return addr != MAP_FAILED ? addr : NULL;
}

# ============================================================
# CRYPTOGRAPHY & SECURITY
# ============================================================

int constant_time_compare(const void *a, const void *b, size_t len) {
    const unsigned char *x = a, *y = b;
    unsigned char result = 0;
    for (size_t i = 0; i < len; i++) {
        result |= x[i] ^ y[i];
    }
    return result == 0;
}

void secure_zero(void *ptr, size_t len) {
    volatile unsigned char *p = ptr;
    while (len--) {
        *p++ = 0;
    }
}

# ============================================================
# NETWORK PROGRAMMING WITH EPOLL
# ============================================================

int setup_epoll_server(int port) {
    int epoll_fd = epoll_create1(0);
    int server_fd = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);

    struct sockaddr_in addr = {
        .sin_family = AF_INET,
        .sin_port = htons(port),
        .sin_addr = { .s_addr = INADDR_ANY }
    };

    bind(server_fd, (struct sockaddr*)&addr, sizeof(addr));
    listen(server_fd, SOMAXCONN);

    struct epoll_event ev = {
        .events = EPOLLIN | EPOLLET,
        .data.fd = server_fd
    };

    epoll_ctl(epoll_fd, EPOLL_CTL_ADD, server_fd, &ev);
    return epoll_fd;
}