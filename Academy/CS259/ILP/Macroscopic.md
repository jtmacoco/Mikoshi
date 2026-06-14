## <span style="color:rgb(112, 48, 160)">Analogy</span>:
- Now instead of just working with laundry machines we can say we have all the hardware we need
- So now we are working with laundry mat stores 
## Inherent Sequentiality:
- So order needs to be preserved because if the hardware messes this up the program will get different answers
## Artificial Sequentiality: 
-  Example from the slides was the re-use of a variable:
```
T1 = A + B
T2 = C + D
X = T1 * T2
T1 = E * F
Y = T1 + G
```
- So in the code above re-using T1 for different operations
- The compiler see's that T1 is done after X so it re-uses T1 for another calculation instead of allocating more memory to create a new variable

## Data Hazards:
### Read After Write(RAW):
- basically the next instruction is reading after a write 
```
S1: R1 = R2 + R2
S2: R4 = R1 + R6
``` 
- don't wan them in the same functional unit 
- Basically don't want them in the same boat
- Single level look ahead only has to worry about RAW
### Write After Write(WAR):
Ex of WAR:
```
S1: R4 = R1 + R6
S2: R1 = R2 + R3
```
- Can be avoided by buffering the source operands
## Very Long Instruction Word (VLIW):
- Control unit (Disneyland employee) is the bottleneck of the system
- So intel and HP got rid of Control unit.
- So shoving multiple instructions
### <span style="color:rgb(112, 48, 160)">Analogy</span>: 
- Think of a factory where workers do different tasks. In normal factory (traditional cpu) a manager tells each worker what to do step by step. But in VLIW factor, the manager just gives a big instruction sheet that tells multiple workers what to do at the same time. This way all the workers stay busy and things get done faster.
- Think now so the CPU is no longer telling us which instruction should run in parallel, this now has to be done by the compiler
- This was meant to speed things up since the CPU deciding on what tasks should run concurrently was done dynamically at run time 
- Now it was up to the programmer to handle the hazards
## Resource Hazards

[[CS259]]