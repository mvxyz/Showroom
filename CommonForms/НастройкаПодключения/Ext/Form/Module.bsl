﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбменВызовСервера.СброситьСостояниеЗагрузкиЧастейСообщений();

	Набор = Константы.СоздатьНабор();
	Набор.Прочитать();

	ЗначениеВРеквизитФормы(Набор, "НаборКонстант");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УстановитьВидимостьКнопокОчистки();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ПовторитьСинхронизацию" Тогда

		Готово(Неопределено);

	ИначеЕсли ИмяСобытия = "ВыполненоПодключениеКЦентральнойБазе" Тогда

		Закрыть();

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаборКонстантАдресЦентральнойБазыПриИзменении(Элемент)

	ЗаписатьОбъект();
	УстановитьВидимостьКнопокОчистки();

КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантПользовательЦентральнойБазыПриИзменении(Элемент)

	ЗаписатьОбъект();
	УстановитьВидимостьКнопокОчистки();

КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантПарольПользователяПриИзменении(Элемент)

	ЗаписатьОбъект();
	УстановитьВидимостьКнопокОчистки();

КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантСрокУстареванияДанныхПриИзменении(Элемент)

	ЗаписатьОбъект();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)

	ОбменКлиент.ВыполнитьПодключениеКСерверу(ЭтаФорма, НаборКонстант, ДатаНачалаСинхронизации);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьКнопокОчистки()

	Элементы.НаборКонстантАдресЦентральнойБазы.КнопкаОчистки = 
		ЗначениеЗаполнено(НаборКонстант.АдресЦентральнойБазы);

	Элементы.НаборКонстантПользовательЦентральнойБазы.КнопкаОчистки = 
		ЗначениеЗаполнено(НаборКонстант.ПользовательЦентральнойБазы);

	Элементы.НаборКонстантПарольПользователя.КнопкаОчистки = 
		ЗначениеЗаполнено(НаборКонстант.ПарольПользователя);

КонецПроцедуры

&НаСервере
Процедура ЗаписатьОбъект()

	Набор = РеквизитФормыВЗначение("НаборКонстант");
	Набор.Записать();

	ЗначениеВРеквизитФормы(Набор, "НаборКонстант");

	Модифицированность = Ложь;

	ОбновитьПовторноИспользуемыеЗначения();

КонецПроцедуры

#КонецОбласти