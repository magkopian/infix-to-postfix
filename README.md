<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<h3>Description:</h3>
<p>
This is an infix to postfix converter implemented with C, Flex and Bison. For every infix expression the program calculates the postfix equivalent and the mathematical result.
</p>

<p>
The user can either input the infix expressions directly to the program or load them from a file. There are supported all the basic operands +, -, *, /, ^, %. But there
is not supported the unary minus. Also there are supported only integer numbres.
</p>

<h3>Compilation:</h3>

<p>
To compile the code, you just use the makefile by running: <br>
<code>make</code><br>
For this to work, the gcc compiler, the make, the flex and the bison programs have to be installed. 
</p>

<h3>How to use:</h3>

<p>
To input the infix expressions directly to the program, you just run it like this: <br>
<code>./in2post</code><br>
</p>

<p>
To give the input via a file, you have to specify the file path as an argument like this: <br>
<code>./in2post path/to/file</code><br>
Every expression must be on its own line. All empty space is ignored, you can you as many new lines, tabs and spaces you want.
</p>

</body>
</html>


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/magkopian/c-code-calculator/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

