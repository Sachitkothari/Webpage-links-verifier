This program takes a link as input and logs any dead links found in it.
If the original link is invalid (not a link) it logs a message asking user to enter a valid link.
If it is a valid link format but not a real link it returns a Fail in the test case and saves a screenshot of what the webpage shows trying to open the link.

To run, use:
robot --variable URL:Link test.robot

For example:
robot --variable URL:https://megamitensei.fandom.com/wiki/List_of_Persona_5_Royal_Personas test.robot
