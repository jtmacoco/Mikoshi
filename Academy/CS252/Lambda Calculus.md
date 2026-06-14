# Church numeral
1) A representation of a number using functions
2) A recipe  for making making the numbers, in any format given:
	- a representation of zero
	- a matching successor function
3) Apply a function to a given value n times

$Zero=\lambda s.\lambda z.z$

$One = \lambda s. \lambda z. s z$
$Two = \lambda s. \lambda z. s(s z)$
