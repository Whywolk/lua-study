-- генерация задачи 3 +- 1
task_in = 3
task_in_delta = 1

-- выполнение задачи 5 +- 2
task_exec = 5
task_exec_delta = 2

-- размер буферной памяти
buffer_size = 1
buffer = {}
task_exec_finish = {}

-- время, через которое задача отбрасывается
old_task_time = 12

-- кол-во генерируемых задач
generate_tasks_count = 200

-- общее время моделирования
model_time = 0
model_time_task_exec = 0
buffer_free_time = 0

task_exec_total = 0

task_success = 0
task_lost = 0
task_lost_old = 0



function random(num, delta)
    local r = math.random() - 0.5
    return num + r * delta * 2
end

function get_task_in_tau()
    return random(task_in, task_in_delta)
end

function get_task_exec_tau()
    return random(task_exec, task_exec_delta)
end

function clear_old_times(list, time)
    tmp = {}
    for j = 1, #list do
        if list[j] > time then
            table.insert(tmp, list[j])
        end
    end
    list = tmp
    return list
end

function clear_buffer()
    tmp = {}
    for j = 1, #buffer do
        if buffer[j] > model_time then
            table.insert(tmp, buffer[j])
        end
    end
    buffer = tmp
end

function clear_exec()
    tmp = {}
    for j = 1, #task_exec_finish do
        if task_exec_finish[j] > model_time then
            table.insert(tmp, task_exec_finish[j])
        end
    end
    task_exec_finish = tmp
end


function model(n)
    for i = 1, n do
        tau_task_in = get_task_in_tau()
        model_time = model_time + tau_task_in
    
        -- очистить в буфере и компьютере старые записи
        buffer = clear_old_times(buffer, model_time)
        task_exec_finish = clear_old_times(task_exec_finish, model_time)
    
        if #buffer < buffer_size then

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
                -- иначе отправляем на выполнение колмпьютеру
                tau_task_exec = get_task_exec_tau()
                task_exec_total = task_exec_total + tau_task_exec -- stats
                model_time_task_exec = buffer_free_time + tau_task_exec
                -- сохраняем время окончания выполнения
                table.insert(task_exec_finish, model_time_task_exec)

                task_success = task_success + 1
            end
        else
            task_lost = task_lost + 1
        end
    end
end

model(generate_tasks_count)

print(string.format('Время моделирования %f', model_time_task_exec))
print(string.format('Время работы компьютера %f', task_exec_total))
print(string.format('Всего задач сгенерировано %d', generate_tasks_count))
print(string.format('Выполнено задач %d', task_success))
print(string.format('Потеряно задач %d', task_lost))
print(string.format('Потеряно задач по условию %d', task_lost_old))
print(string.format('Загрузка компьютера %.3f', task_exec_total/model_time_task_exec))
print(string.format('Среднее время компьютера %.3f', task_exec_total/task_success))
