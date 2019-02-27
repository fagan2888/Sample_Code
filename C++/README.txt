// File name: README.txt// Author: Shijie Shi// VUnetid: shis2// Email: shijie.shi@vanderbilt.edu// Class: CS2201// Date: 11/10/2017// Honor statement: I have neither received or given any unauthorized help.// Assignment Number: 071. State your name and email address.Shijie Shi. shijie.shi@vanderbilt.edu2. After reviewing this spec and the .h file, please estimate/report how many hours you think it will take you to complete this project. [This is just an estimate and does not affect your grade.] My initial estimation was about 15 hours.3. How many hours did you actually spend total on this assignment? [This information will not affect your grade.] I think I spent around 15 hours on this assignment.

4. Who/What did you find helpful for this project? If you received assistance from a person, who were they and what assistance did they provide? 
Reading the spec multiple times helped me to understand how to implement the required methods.

5. Did you access any other reference material other than this project description and the class text? Please list them. 
I read pages 40-46 of the class text to understand the public inheritance.

6. How did you test that the final program is correct? How did you test that your stack and queue classes are correct? 
I tested the final program with the test1.txt and text2.txt file.
I tested the stack class with hw5 and queue class with hw6.

7. Which agenda method, FIFO or LIFO, seems to be faster at finding a solution to a given maze? Justify your answer. 
When the ending location is right next to (or very close to) the start point, FIFO performs better than the LIFO. When the ending locations is far away from the start point, LIFO performs better than FIFO. The reason is FIFO exams every nodes around the start point first while LIFO quickly moves away from the start point, goes to the further points quickly.


8. If you failed to mark maze locations as visited, how would it have affected your ability to determine if a solvable maze was indeed solvable? Would a LIFO solver still be able to correctly determine if a maze was solvable for all solvable mazes? Would a FIFO solver still be able to correctly determine if a maze was solvable for all solvable mazes? 
If failed to mark maze locations, it could lead to infinit agenda list so the program will continue running until we manually stop it. For most of the solvable mazes, neither LOFO solver nor FIFO solver can correctly determine if a maze is solvable. There could be some special mazes that FIFO and LIFO can solve correctly but the ability to solve totally depends on the order of the agenda and the shape of the the solvable path. 

9. What did you enjoy about this assignment? What did you hate? Did we provide too much code or not enough code to make it interesting?
I like this assignment. It takes me some time to fully understand the assignment but I think it is a good assignment.
 
10. Was this project description lacking in any manner? Please be specific. 
No, I don't find any.

11. Do you have any suggestions for improving this assignment? 
I don't have any suggestions.

12. Any other information you would like to include.
I don't have any suggestions.