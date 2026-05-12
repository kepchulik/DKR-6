const
  MAX = 10;

type
  TNode = record
    data: integer;
    prev, next: integer;
    used: boolean;
  end;

var
  list: array[1..MAX] of TNode;
  head: integer;
  count: integer;

procedure InitList;
var
  i: integer;
begin
  head := 0;
  count := 0;

  for i := 1 to MAX do
  begin
    list[i].data := 0;
    list[i].prev := 0;
    list[i].next := 0;
    list[i].used := false;
  end;
end;

function GetFreeIndex: integer;
var
  i: integer;
begin
  GetFreeIndex := 0;

  for i := 1 to MAX do
    if not list[i].used then
    begin
      GetFreeIndex := i;
      exit;
    end;
end;

procedure AddToEnd(value: integer);
var
  idx, tail: integer;
begin
  if count = MAX then
  begin
    writeln('Ошибка: список заполнен!');
    exit;
  end;

  idx := GetFreeIndex;
  list[idx].data := value;
  list[idx].used := true;

  if head = 0 then
  begin
    head := idx;
    list[idx].next := idx;
    list[idx].prev := idx;
  end
  else
  begin
    tail := list[head].prev;

    list[idx].next := head;
    list[idx].prev := tail;

    list[tail].next := idx;
    list[head].prev := idx;
  end;

  count += 1;
  writeln('Элемент добавлен в конец списка.');
end;

procedure AddToBeginning(value: integer);
var
  idx, tail: integer;
begin
  if count = MAX then
  begin
    writeln('Ошибка: список заполнен!');
    exit;
  end;

  idx := GetFreeIndex;
  list[idx].data := value;
  list[idx].used := true;

  if head = 0 then
  begin
    head := idx;
    list[idx].next := idx;
    list[idx].prev := idx;
  end
  else
  begin
    tail := list[head].prev;

    list[idx].next := head;
    list[idx].prev := tail;

    list[tail].next := idx;
    list[head].prev := idx;

    head := idx;
  end;

  count += 1;
  writeln('Элемент добавлен в начало списка.');
end;

procedure DeleteByValue(value: integer);
var
  cur, i: integer;
begin
  if head = 0 then
  begin
    writeln('Список пуст.');
    exit;
  end;

  cur := head;

  for i := 1 to count do
  begin
    if list[cur].data = value then
    begin
      if count = 1 then
      begin
        list[cur].used := false;
        list[cur].next := 0;
        list[cur].prev := 0;
        head := 0;  
      end
      else
      begin
        list[list[cur].prev].next := list[cur].next;
        list[list[cur].next].prev := list[cur].prev;

        if cur = head then
          head := list[cur].next;

        list[cur].used := false;
        list[cur].next := 0;
        list[cur].prev := 0;
      end;

      count -= 1;
      writeln('Элемент удален.');
      exit;
    end;

    cur := list[cur].next;
  end;

  writeln('Элемент не найден.');
end;

procedure SearchValue(value: integer);
var
  cur, i: integer;
  found: boolean;
begin
  if head = 0 then
  begin
    writeln('Список пуст.');
    exit;
  end;

  cur := head;
  found := false;

  for i := 1 to count do
  begin
    if list[cur].data = value then
    begin
      writeln('Элемент найден.');
      writeln('Позиция в списке: ', i);
      writeln('Индекс в массиве: ', cur);
      found := true;
    end;

    cur := list[cur].next;
  end;

  if not found then
    writeln('Элемент не найден.');
end;

procedure ShowForward;
var
  cur, i: integer;
begin
  if head = 0 then
  begin
    writeln('Список пуст.');
    exit;
  end;

  writeln;
  writeln('Визуализация списка по next:');
  cur := head;

  for i := 1 to count do
  begin
    write('[', cur, ': ', list[cur].data, ']');

    if i < count then
      write(' <-> ');

    cur := list[cur].next;
  end;

  writeln('  -> снова к началу');
end;

procedure ShowBackward;
var
  cur, i: integer;
begin
  if head = 0 then
  begin
    writeln('Список пуст.');
    exit;
  end;

  writeln;
  writeln('Визуализация списка по prev:');
  cur := list[head].prev;

  for i := 1 to count do
  begin
    write('[', cur, ': ', list[cur].data, ']');

    if i < count then
      write(' <-> ');

    cur := list[cur].prev;
  end;

  writeln('  -> снова к хвосту');
end;

procedure ShowMemory;
var
  i: integer;
begin
  writeln;
  writeln('Состояние статической памяти:');
  writeln('Индекс | Данные | Prev | Next | Занят');

  for i := 1 to MAX do
  begin
    writeln(
      i:6, ' | ',
      list[i].data:6, ' | ',
      list[i].prev:4, ' | ',
      list[i].next:4, ' | ',
      list[i].used
    );
  end;

  writeln('Количество элементов: ', count);
  writeln('Голова списка: ', head);
end;

procedure ClearList;
begin
  InitList;
  writeln('Список очищен.');
end;

procedure Menu;
begin
  writeln;
  writeln('========== МЕНЮ ==========');
  writeln('1. Добавить элемент в начало');
  writeln('2. Добавить элемент в конец');
  writeln('3. Удалить элемент по значению');
  writeln('4. Найти элемент');
  writeln('5. Показать список по next');
  writeln('6. Показать список по prev');
  writeln('7. Показать состояние памяти');
  writeln('8. Очистить список');
  writeln('0. Выход');
  writeln('==========================');
  write('Ваш выбор: ');
end;

var
  choice: integer;
  value: integer;

begin
  InitList;

  repeat
    Menu;
    readln(choice);

    case choice of
      1:
      begin
        write('Введите значение: ');
        readln(value);
        AddToBeginning(value);
      end;

      2:
      begin
        write('Введите значение: ');
        readln(value);
        AddToEnd(value);
      end;

      3:
      begin
        write('Введите значение для удаления: ');
        readln(value);
        DeleteByValue(value);
      end;

      4:
      begin
        write('Введите значение для поиска: ');
        readln(value);
        SearchValue(value);
      end;

      5:
        ShowForward;

      6:
        ShowBackward;

      7:
        ShowMemory;

      8:
        ClearList;

      0:
        writeln('Завершение программы.');

    else
      writeln('Ошибка: неверный пункт меню.');
    end;

  until choice = 0;
end.