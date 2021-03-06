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

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВТестовомПриложенииЕстьСообщение(Парам01)","ВТестовомПриложенииЕстьСообщение","Когда в Тестовом приложении есть сообщение """"");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВТестовомПриложенииНетСообщения(Парам01)","ВТестовомПриложенииНетСообщения","Когда в Тестовом приложении нет сообщения """"");

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
Функция ЕстьСообщениеВТестовомПриложении(ИскомыйТекст)

	ТекстыСообщенийПользователю = КонтекстСохраняемый.ТестовоеПриложение.ПолучитьАктивноеОкно().ПолучитьТекстыСообщенийПользователю();
	Для каждого ТекстСообщения Из ТекстыСообщенийПользователю Цикл
		Если Найти(НРег(ТекстСообщения),НРег(ИскомыйТекст)) > 0 Тогда
			Возврат Истина;
		КонецЕсли;	 
	КонецЦикла;	

	Возврат Ложь;
	
КонецФункции // ЕстьСообщениеВТестовомПриложении()
 


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
//Когда в Тестовом приложении есть сообщение ""
//@ВТестовомПриложенииЕстьСообщение(Парам01)
Процедура ВТестовомПриложенииЕстьСообщение(Текст) Экспорт

	Если НЕ ЕстьСообщениеВТестовомПриложении(Текст) Тогда
		ВызватьИсключение "Сообщение """ + Текст + """ НЕ выведено пользователю тестового приложения";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
//Когда в Тестовом приложении нет сообщения ""
//@ВТестовомПриложенииНетСообщения(Парам01)
Процедура ВТестовомПриложенииНетСообщения(Текст) Экспорт

	Если ЕстьСообщениеВТестовомПриложении(Текст) Тогда
		ВызватьИсключение "Сообщение """ + Текст + """ выведено пользователю тестового приложения";
	КонецЕсли;
	
КонецПроцедуры

//окончание текста модуля