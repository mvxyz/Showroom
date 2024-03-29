﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтправлятьСразу = ПолучитьФункциональнуюОпцию("ОтправлятьДанныеСразу");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбработчикОжиданияУстановитьПодписьКДатеОбновления();
	ПодключитьОбработчикОжидания(
	"ОбработчикОжиданияУстановитьПодписьКДатеОбновления", 60, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ВыполненоПодключениеКЦентральнойБазе" Тогда
		ОбменВызовСервера.ВыполнитьДействияПослеПервогоПодключенияКСерверу();
		Элементы.Список.Обновить();

	ИначеЕсли ИмяСобытия = "ВыполненоПолноеУдаление" Тогда
		Элементы.Список.Обновить();

	ИначеЕсли ИмяСобытия = "ПоявилисьНеотправленныеДанные" Тогда
		Элементы.Список.Обновить();
		ОбщегоНазначенияВызовСервера.УстановитьЗначениеКонстанты("ЕстьНеотправленныеДанные", Истина);

	ИначеЕсли ИмяСобытия = "ИзмененРежимРаботыПриложения" Тогда
		Закрыть();

	ИначеЕсли ИмяСобытия = "НачатьСинхронизацию" Тогда
		ОтключитьОбработчикОжидания("ОбработчикОжиданияУстановитьПодписьКДатеОбновления");

	ИначеЕсли ИмяСобытия = "ВыполняетсяСинхронизация" Тогда

		Если Не Элементы.ГруппаКнопкаОбновить.ТекущаяСтраница = Элементы.ВПроцессе Тогда
			Элементы.ГруппаКнопкаОбновить.ТекущаяСтраница = Элементы.ВПроцессе;
		КонецЕсли;
		ОписаниеПоследнегоОбновления = Параметр.ОписаниеПоследнегоОбновления;

	ИначеЕсли ИмяСобытия = "СинхронизацияЗавершена" Тогда

		ОбработчикОжиданияУстановитьПодписьКДатеОбновления();
		ПодключитьОбработчикОжидания(
			"ОбработчикОжиданияУстановитьПодписьКДатеОбновления", 60, Ложь);

		Элементы.Список.Обновить();

	ИначеЕсли ИмяСобытия = "ОбновитьДатуСинхронизации" Тогда
		Элементы.Список.Обновить();

	КонецЕсли;

	Если Не ИмяСобытия = "ВыполняетсяСинхронизация" Тогда
		ОбменКлиент.УстановитьПодписьКДатеОбновления(
			Элементы, ОписаниеПоследнегоОбновления);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ФормаСинхронизировать(Команда)
	
	ОбменКлиент.НачатьСинхронизацию(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОтборПриИзменении(Элемент)
	
	Список.Отбор.Элементы.Очистить();
	
	УстановитьОтборПоКонтрагенту();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	Если Не ОтправлятьСразу Тогда
		Оповестить("ПоявилисьНеотправленныеДанные");
	Иначе
		ОбменКлиент.НачатьСинхронизацию(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеПроцедурыИФункцииСинхронизация

&НаКлиенте
Процедура ОбработчикОжиданияУстановитьПодписьКДатеОбновления()

	ОбменКлиент.УстановитьПодписьКДатеОбновления(
		Элементы, ОписаниеПоследнегоОбновления);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСинхронизациюНачало() 

	ОтключитьОбработчикОжидания("ОбработчикОжиданияУстановитьПодписьКДатеОбновления");

	ПараметрыЗапуска = Новый Структура();
	ПараметрыЗапуска.Вставить("РежимСинхронизации", "ВыполнитьСинхронизацию");

	Оповестить("НачатьСинхронизацию", ПараметрыЗапуска);

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоКонтрагенту()

	Если ЗначениеЗаполнено(КонтрагентОтбор) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Контрагент", КонтрагентОтбор,
			ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункцииСинхронизация

#КонецОбласти



