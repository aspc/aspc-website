#!/usr/bin/env python3

# Writes out the HTML output for the liaisons page based on the input CSV file
# CSV file should contain the following columns, in the exact order as listed:
# Department name, department chair name, department chair email,
# no. of liaisons, liason 1 name, liason 1 email, liason 2 name, liason 2 email, 
# etc. 

import csv, html

with open('liaisons_output.txt', 'w') as output_file:
    with open('liaisons.csv') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        for row in csv_reader:
            # Not a column with names and at least one valid liason
            if line_count != 0 and "'2" in row[4] or '’2' in row[4] or '20' in row[4]:
                department_name = html.escape(row[0])
                output_file.write(f'<h4 class="title is-4 margin-bottom-1">{department_name}</h4>\n')
                output_file.write('<p class="margin-bottom-2">\n')
                for i in range(4, len(row), 2):
                    if ("'2" in row[i] or '’2' in row[i] or '20' in row[i]):
                        liason_name = html.escape(row[i])
                        liason_email = row[i + 1]
                        output_file.write(f'\t\t{liason_name} (<a href="mailto:{liason_email}">{liason_email}</a>)<br>\n')
                output_file.write('</p>\n')
                line_count += 1
        print(f'Processed {line_count} departments.')