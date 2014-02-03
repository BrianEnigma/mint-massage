#Mint Massage

##Purpose

The Mint Massage script will take a CSV export from your Mint.com account and normalize the categories into consistent groups. For example, Dentist, Doctor, and Massage Therapy all get normalized into "Health." The various sub-categories of Utilities, all get normalized to "Utilities."

##Considerations

There is a limited list of categories listed at the top of the script. These work for me. They may not work for you. Feel free to fork the script and edit your own categories.

If a transaction is found that doesn't yet have a mapping, the script exits by throwing a message that there is no mapping. This lets you go and add that category mapping. The thought behind this was that I wanted it to loudly fail rather than silently make possible mistakes.

##Input/Output

**Input:** Put one or more CSV account exports on the command line.

**Output:** Two files are creaded: expenses-2013-expenses.csv and expenses-2013-income.csv. One is only expenses, the other is only income. The categories have been normalized, as per the script's rules.
