-- генерация задачи 3 +- 1
task_in = 3
task_in_delta = 1

-- выполнение задачи 5 +- 2
task_exec = 5
task_exec_delta = 2

-- размер буферной памяти
buffer_size = 1
buffer_count = 0

-- время, через которое задача отбрасывается
old_task_time = 12

-- кол-во генерируемых задач
tasks_count = 200

-- общее время моделирования
model_time = 0
model_time_task_exec = 0

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

for i = 1, tasks_count do
    tau_task_in = get_task_in_tau()
    model_time = model_time + tau_task_in

    if buffer_count < buffer_size and model_time >= model_time_task_exec then
        buffer_count = buffer_count + 1
        task_in_buffer_time = model_time - model_time_task_exec
        
        -- удаляем сообщение, которое в буфере > 12 секунд
        if task_in_buffer_time > 12 then
            buffer_count = buffer_count - 1
            task_lost_old = task_lost_old + 1
            goto continue
        end
    
        tau_task_exec = get_task_exec_tau()
        task_exec_total = task_exec_total + tau_task_exec
        model_time_task_exec = model_time + tau_task_exec

        buffer_count = buffer_count - 1
        task_success = task_success + 1
    else
        task_lost = task_lost + 1
    end
    ::continue::
end

print(string.format('Время моделирования %f', model_time_task_exec))
print(string.format('Всего задач сгенерировано %d', tasks_count))
print(string.format('Выполнено задач %d', task_success))
print(string.format('Потеряно задач %d', task_lost))
print(string.format('Потеряно задач по условию %d', task_lost_old))
print(string.format('Загрузка компьютера %.3f', task_exec_total/model_time_task_exec))
print(string.format('Среднее время компьютера %.3f', task_exec_total/task_success))