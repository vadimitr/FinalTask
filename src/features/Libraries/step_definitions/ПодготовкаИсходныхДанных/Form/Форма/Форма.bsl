﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебные функции и процедуры
///////////////////////////////////////////////////

&НаКлиенте
// контекст фреймворка Vanessa-Behavior
Перем Ванесса;
 
&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;
 
&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-Behavior.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;
	
	ВсеТесты = Новый Массив;

	//описание параметров
	//Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯДобавляюПользователяИБСРолью(Парам01,Парам02)","ЯДобавляюПользователяИБСРолью","Дано Я добавляю пользователя ИБ ""Оператор"" с ролью ""Оператор""");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯЗагружаюФикстуры(Парам01)","ЯЗагружаюФикстуры","Дано Я загружаю фикстуры ""Номенклатура""");

	Возврат ВсеТесты;
КонецФункции
	
&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции
	
&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции

&НаКлиенте
Функция ПолучитьПутьКФайлуОтносительноКаталогаФичи(ИмяФайлаСРасширением)
	
	ПутьКФайлу = "";
	
	СостояниеВанесса = Ванесса.ПолучитьСостояниеVanessaBehavior();
	
	ПутьКТекущемуФичаФайлу = СостояниеВанесса.ТекущаяФича.ПолныйПуть;
	
	ПутьКФайлу = Лев(ПутьКТекущемуФичаФайлу, СтрНайти(ПутьКТекущемуФичаФайлу, "features") - 1) + ИмяФайлаСРасширением;
	
	Возврат ПутьКФайлу;
КонецФункции

&НаКлиенте
Процедура ЗагрузитьFixtureИзМакета(ИмяМакета)
	Ванесса.ЗапретитьВыполнениеШагов();	

	Адрес = "";
	НачальноеИмяФайла = ПолучитьПутьКФайлуОтносительноКаталогаФичи("tools\Выгрузка и загрузка данных XML.epf");
	НачатьПомещениеФайла(Новый ОписаниеОповещения("ЗагрузитьFixtureИзМакетаЗавершение", ЭтотОбъект, ИмяМакета), Адрес, НачальноеИмяФайла, Ложь);
	
КонецПроцедуры // ЗагрузитьФикстурыИзМакета()

&НаКлиенте
Процедура ЗагрузитьFixtureИзМакетаЗавершение(Результат, Адрес, ИмяФайла, ИмяМакета) Экспорт

	ЗагрузитьFixtureИзМакетаЗавершениеНаСервере(Адрес, ИмяМакета);
	
	Ванесса.ПродолжитьВыполнениеШагов();

КонецПроцедуры // ЗагрузитьFixtureИзМакетаЗавершение()

&НаСервере
Процедура ЗагрузитьFixtureИзМакетаЗавершениеНаСервере(Адрес, ИмяМакета)

	//1
	ИмяВременногоФайла1 = ПолучитьИмяВременногоФайла();
	
	ДД = ПолучитьИзВременногоХранилища(Адрес);
	ДД.Записать(ИмяВременногоФайла1);
	ВО = ВнешниеОбработки.Создать(ИмяВременногоФайла1, Ложь);
	
	//2
	ИмяВременногоФайла2 = ПолучитьИмяВременногоФайла();
	
	Текст = РеквизитФормыВЗначение("Объект").ПолучитьМакет(ИмяМакета).ПолучитьТекст();
	ТД = Новый ТекстовыйДокумент;
	ТД.УстановитьТекст(Текст);
	ТД.Записать(ИмяВременногоФайла2, КодировкаТекста.UTF8);
	
	ВО.ВыполнитьЗагрузку(ИмяВременногоФайла2);
	
	Файл = Новый Файл(ИмяВременногоФайла1);
	Если Файл.Существует() Тогда
		УдалитьФайлы(ИмяВременногоФайла1);
	КонецЕсли;
	Файл = Новый Файл(ИмяВременногоФайла2);
	Если Файл.Существует() Тогда
		УдалитьФайлы(ИмяВременногоФайла2);
	КонецЕсли;
	
КонецПроцедуры // ЗагрузитьFixtureИзМакетаЗавершение()

&НаСервере
Функция ПользовательИБДобавленНаСервере(Знач ИмяПользователя, Знач ИмяРоли)
	
	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "У текущего пользователя не достаточно прав для создание пользователей ИБ!";
		Сообщение.Сообщить(); 
		Возврат Ложь;
	КонецЕсли;
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователя);
	
	Если ПользовательИБ = Неопределено Тогда
		Попытка
			ПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
			ПользовательИБ.Имя = ИмяПользователя;
			ПользовательИБ.ПоказыватьВСпискеВыбора = Истина;
			ПользовательИБ.Роли.Добавить(Метаданные.Роли[ИмяРоли]);
			ПользовательИБ.Записать();
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить();
			Возврат Ложь;
		КонецПопытки;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

///////////////////////////////////////////////////
//Работа со сценариями
///////////////////////////////////////////////////

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт
	
КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт
	
КонецПроцедуры



///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//Дано Я добавляю пользователя ИБ "Оператор" с ролью "Оператор"
//@ЯДобавляюПользователяИБСРолью(Парам01,Парам02)
Процедура ЯДобавляюПользователяИБСРолью(ИмяПользователя,ИмяРоли) Экспорт

	Если НЕ ПользовательИБДобавленНаСервере(ИмяПользователя,ИмяРоли) Тогда
		ВызватьИсключение "Пользователь ИБ " + ИмяПользователя + " не создан!";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
//Дано Я загружаю фикстуры "Номенклатура"
//@ЯЗагружаюФикстуры(Парам01)
Процедура ЯЗагружаюФикстуры(ИмяМакета) Экспорт
	ЗагрузитьFixtureИзМакета(ИмяМакета);
КонецПроцедуры

//окончание текста модуля