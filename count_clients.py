import csv

def count_clients(path):
    with open(path, 'r') as file:
        count = 0
        csv_reader = csv.reader(file, delimiter='\n')
        for row in csv_reader:
            count += 1

    return count

print(f'Количество клиентов: {count_clients('dataset_clients.csv')}')