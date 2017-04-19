/**
 * addtest.S
 *
 * Add Test
 *
 * This test exercises the various add instructions in the RISC-V ISA.
 * This also demonstrates how *.S files differ from *.s files.
 **/

/**
 * When files have a *.S (vs *.s) extension, the compiler will run the
 * preprocessor on the file before assembling it. Thus, you can leverage the
 * C preprocessor (#define, #include, #ifdef, etc.) in your assembly code.
 *
 * Also, you can use C++-style comments (//) in addition to the normal
 * assembly comments (#, slash-*). Be careful with using #, because certain words
 * (e.g. if, define, etc.) may be interpreted as preprocessor directives.
 **/

// The initial value to seed the test with
#define TEST_SEED               512

    .text                       // Declare the code to be in the .text segment
    .global main                // Make main visible to the linker
main:
    nop
    addi x0, x0, 0
    li a0, 2
    li a1, 2
    beq a0, a1, success
    j failure

success:
    li a3, 1
    nop

failure:
    li a3, 2
    nop
