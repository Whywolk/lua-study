-- генерация сообщения 3 +- 1
task_in = 3
task_in_delta = 1

-- обработка сообщения 5 +- 2
task_exec = 5
task_exec_delta = 2

-- время, через которое сообщение считается старым 
old_task_time = 12

-- размер буферной памяти
buffer_size = 1
buffer = {}

-- кол-во генерируемых сообщений
generate_tasks_count = 200

-- общее время моделирования
model_time = 0
model_time_task_exec = 0
buffer_free_time = 0

-- статистика
task_exec_total = 0
task_exec_finish = {}

task_success = 0
task_lost = 0
task_lost_old = 0


-- генерация случайных чисел с разбросом num +- delta
function random(num, delta)
    local r = math.random() - 0.5
    return num + r * delta * 2
end

-- генерация времени появления сообщения
function get_task_in_tau()
    return random(task_in, task_in_delta)
end

-- генерация времени обработки сообщения
function get_task_exec_tau()
    return random(task_exec, task_exec_delta)
end

-- очистка старых записей в списке
function clear_old_times(list, time)
    tmp = {}
    for j = 1, #list do
        if list[j] > time then
            table.insert(tmp, list[j])
        end
    end
    return tmp
end

-- моделирование задачи
function model(n)
    for i = 1, n do
        tau_task_in = get_task_in_tau()
        model_time = model_time + tau_task_in
    
        -- очистить в буфере и компьютере старые записи
        buffer = clear_old_times(buffer, model_time)
        task_exec_finish = clear_old_times(task_exec_finish, model_time)
    
        -- если буфер заполнен, то теряем сообщение
        if #buffer == buffer_size then
            task_lost = task_lost + 1
        else
            -- иначе добавляем в буфер
            if #task_exec_finish == 0 then
                buffer_free_time = model_time
            else
                buffer_free_time = math.max(table.unpack(task_exec_finish))
            end
            -- сохраняем время освобождения буфера
            table.insert(buffer, buffer_free_time)
            
            -- удаляем сообщение, которое в буфере > 12 секунд
            task_in_buffer_time = buffer_free_time - model_time
            if task_in_buffer_time > old_task_time then
                task_lost_old = task_lost_old + 1
            else
                -- иначе отправляем на обработку компьютеру
                tau_task_exec = get_task_exec_tau()
                task_exec_total = task_exec_total + tau_task_exec
                model_time_task_exec = buffer_free_time + tau_task_exec
                -- сохраняем время окончания обработки
                table.insert(task_exec_finish, model_time_task_exec)

                task_success = task_success + 1
            end
        end
    end
end

model(generate_tasks_count)

print(string.format('Время моделирования: %f', model_time_task_exec))
print(string.format('Время работы компьютера: %f', task_exec_total))
print('--------------------------')
print(string.format('Всего сообщений сгенерировано: %d', generate_tasks_count))
print(string.format('Обработано сообщений: %d', task_success))
print(string.format('Потеряно сообщений: %d', task_lost))
print(string.format('Потеряно сообщений по условию: %d', task_lost_old))
print('--------------------------')
print(string.format('Загрузка компьютера: %.3f', task_exec_total/model_time_task_exec))
print(string.format('Среднее время обработки на компьютере: %.3f', task_exec_total/task_success))
