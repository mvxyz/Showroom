﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	БольшойЭкран = ЭтоУстройствоСБольшимЭкраном();
	ЭтоЧистаяБаза = ОбщегоНазначенияВызовСервера.ЭтоЧистаяБаза();
	ИнициированаОчисткаБазы = ОбщегоНазначенияВызовСервера.ИнициированаОчисткаБазы();
	
	ЗаполнитьСписокРазделов();
	
	Если БольшойЭкран Тогда
		Элементы.РазделыКартинка.Высота = 4;
	КонецЕсли;
	
	Элементы.ГруппаРазделы.Видимость = Истина;
	
	Заголовок = НСтр("ru = 'Визард: Выставочный зал'; en = 'Wizard: Far Pavilion'");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбработчикОжиданияУстановитьПодписьКДатеОбновления();
	ПодключитьОбработчикОжидания(
		"ОбработчикОжиданияУстановитьПодписьКДатеОбновления", 60, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ОбновитьДатуСинхронизации" Тогда
		ОбменКлиент.УстановитьПодписьКДатеОбновления(
			Элементы, ОписаниеПоследнегоОбновления);

	ИначеЕсли ИмяСобытия = "НачатьСинхронизацию" Тогда

		ОтключитьОбработчикОжидания("ОбработчикОжиданияУстановитьПодписьКДатеОбновления");

		Параметр.Вставить("ДатаНачалаСинхронизации", ТекущаяДата());
		Параметр.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);

		ЗаданиеЗапущено = 
			ОбменВызовСервера.ЗапуститьСинхронизациюССерверомВФоне(
				Параметр, ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища);

		Если ЗаданиеЗапущено Тогда
			ПодключитьОбработчикОжидания("ВыполнитьСинхронизациюПроверитьИсполнение", 0.2, Истина);
		КонецЕсли;

	ИначеЕсли ИмяСобытия = "ВыполняетсяСинхронизация" Тогда

		Если Не Элементы.ГруппаКнопкаОбновить.ТекущаяСтраница = Элементы.ВПроцессе Тогда
			Элементы.ГруппаКнопкаОбновить.ТекущаяСтраница = Элементы.ВПроцессе;
		КонецЕсли;

		Если Параметр.ОбновитьДатуСинхронизации Тогда
			Оповестить("ОбновитьДатуСинхронизации");
		КонецЕсли;

		Если Параметр.ЗаданиеВыполнено 
		 Или Не Параметр.СообщениеОбОшибке = Неопределено Тогда
			ОбменКлиент.ЗавершитьСинхронизацию(ЭтаФорма, СведенияОЗагруженныхДанных);
		Иначе
			ПодключитьОбработчикОжидания("ВыполнитьСинхронизациюПроверитьИсполнение", 2, Истина);
		КонецЕсли;

	ИначеЕсли ИмяСобытия = "СинхронизацияЗавершена" Тогда
		
		ЗаполнитьСписокРазделов();
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияУстановитьПодписьКДатеОбновления", 60, Ложь);
		
	ИначеЕсли ИмяСобытия = "ВыполненоПодключениеКЦентральнойБазе" Тогда

		ОбменВызовСервера.ВыполнитьДействияПослеПервогоПодключенияКСерверу();

		ОбменКлиент.УстановитьПодписьКДатеОбновления(
			Элементы, ОписаниеПоследнегоОбновления);

	ИначеЕсли ИмяСобытия = "ПовторитьСинхронизацию" Тогда
		ОбменКлиент.НачатьСинхронизацию(ЭтаФорма);

	ИначеЕсли ИмяСобытия = "ПоявилисьНеотправленныеДанные" Тогда

		ОбщегоНазначенияВызовСервера.УстановитьЗначениеКонстанты(
			"ЕстьНеотправленныеДанные", Истина);

		ОбменКлиент.УстановитьПодписьКДатеОбновления(
			Элементы, ОписаниеПоследнегоОбновления);
			
		ЗаполнитьСписокРазделов();

	ИначеЕсли ИмяСобытия = "ОтправитьЗаказВЦентральнуюБазу" Тогда
		ОтправитьОдиночныйЗаказ(Параметр);
	
	ИначеЕсли ИмяСобытия = "ВыполненоПолноеУдаление" Тогда

		ЗаполнитьСписокРазделов();

		ОбменКлиент.УстановитьПодписьКДатеОбновления(
			Элементы, ОписаниеПоследнегоОбновления);

	ИначеЕсли ИмяСобытия = "ВыполненЗапускСистемы" Тогда
		
		Если ИнициированаОчисткаБазы Тогда
			
			ОчисткаБазыДанныхКлиент.ПродолжитьОчисткуБазыДанных();	
			
		Иначе
			
			Если ЭтоЧистаяБаза Тогда
				ПодключитьОбработчикОжидания("ПоказатьФормуНастройкиПодключенияПриЗапуске", 1, Истина);
			Иначе

				Если ОпределитьНеобходимостьЗапускаФоновойСинхронизации() Тогда
					ОбменКлиент.НачатьСинхронизацию(ЭтаФорма);
				КонецЕсли;

			КонецЕсли;
		
		КонецЕсли

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()

	ПараметрыЭкрана = ЭкранКлиентСервер.ПараметрыЭкрана();
	ШиринаЭкрана    = ПараметрыЭкрана[0].Ширина;
	ВысотаЭкрана    = ПараметрыЭкрана[0].Высота;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Синхронизировать(Команда)

	ОбменКлиент.НачатьСинхронизацию(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыРазделы

&НаКлиенте
Процедура РазделыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Разделы.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Раздел = Элементы.Разделы.ТекущиеДанные.ИмяРаздела;
	
	Если Раздел = "Номенклатура" Тогда
		
		ОбщегоНазначенияКлиент.ОткрытьРазделНоменклатура();
		
	ИначеЕсли Раздел = "Контрагенты" Тогда
		
		ОбщегоНазначенияКлиент.ОткрытьРазделКонтрагенты();
	
	ИначеЕсли Раздел = "Заказы" Тогда
		
		ОбщегоНазначенияКлиент.ОткрытьРазделЗаказы();
		
	ИначеЕсли Раздел = "Корзина" Тогда
		
		ОбщегоНазначенияКлиент.ОткрытьРазделКорзина();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазделыОбработкаЗапросаОбновления()

	ОбменКлиент.НачатьСинхронизацию(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДокументыНаРассмотрениеОбработкаЗапросаОбновления()

	ОбменКлиент.НачатьСинхронизацию(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииРабочийСтол

&НаСервере
Процедура ЗаполнитьСписокРазделов()

	Разделы.Очистить();
	
	СтрокаРаздела = Разделы.Добавить();
	СтрокаРаздела.Картинка   = БиблиотекаКартинок.РазделНоменклатура;
	СтрокаРаздела.ИмяРаздела = "Номенклатура";
	СтрокаРаздела.Описание   = ТекстыСообщенийКлиентСерверПовтИсп.ЗаголовокНоменклатура();
	
	СтрокаРаздела = Разделы.Добавить();
	СтрокаРаздела.Картинка   = БиблиотекаКартинок.РазделКонтрагенты;
	СтрокаРаздела.ИмяРаздела = "Контрагенты";
	СтрокаРаздела.Описание   = ТекстыСообщенийКлиентСерверПовтИсп.ЗаголовокКонтрагенты();

	СтрокаРаздела = Разделы.Добавить();
	СтрокаРаздела.Картинка   = БиблиотекаКартинок.РазделЗаказы;
	СтрокаРаздела.ИмяРаздела = "Заказы";
	СтрокаРаздела.Описание   = ТекстыСообщенийКлиентСерверПовтИсп.ЗаголовокЗаказы();
	
	СтрокаРаздела = Разделы.Добавить();
	СтрокаРаздела.Картинка   = БиблиотекаКартинок.Корзина;
	СтрокаРаздела.ИмяРаздела = "Корзина";
	СтрокаРаздела.Описание   = ТекстыСообщенийКлиентСерверПовтИсп.ЗаголовокКорзина();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииСинхронизация

&НаСервере
Функция ОпределитьНеобходимостьЗапускаФоновойСинхронизации()

	Если Не Константы.ИспользоватьФоновуюСинхронизацию.Получить() Тогда
		Возврат Ложь;
	КонецЕсли;

	#Если МобильноеПриложениеСервер ИЛИ МобильныйКлиент Тогда

		ТипСоединения = ИнформацияОбИнтернетСоединении.ПолучитьТипСоединения();

		Если ТипСоединения = ТипИнтернетСоединения.НетСоединения Тогда
			Возврат Ложь;
		ИначеЕсли ТипСоединения = ТипИнтернетСоединения.СотовыеДанные Тогда
		КонецЕсли;

	#КонецЕсли

	Возврат Истина;

КонецФункции

&НаКлиенте
Процедура ОбработчикОжиданияУстановитьПодписьКДатеОбновления()

	ОбменКлиент.УстановитьПодписьКДатеОбновления(
		Элементы, ОписаниеПоследнегоОбновления);

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФормуНастройкиПодключенияПриЗапуске()

	Если ЭтоЧистаяБаза Тогда
		ОбменКлиент.ПоказатьФормуНастройкиПодключения();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСинхронизациюНачало()

	ОтключитьОбработчикОжидания("ОбработчикОжиданияУстановитьПодписьКДатеОбновления");

	ПараметрыЗапуска = Новый Структура();
	ПараметрыЗапуска.Вставить("РежимСинхронизации", "ВыполнитьСинхронизацию");
	ПараметрыЗапуска.Вставить("ДатаНачалаСинхронизации", ТекущаяДата());

	Оповестить("НачатьСинхронизацию", ПараметрыЗапуска);

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьОдиночныйЗаказ(Заказ)

	ОтключитьОбработчикОжидания("ОбработчикОжиданияУстановитьПодписьКДатеОбновления");

	ПараметрыЗапуска = Новый Структура();
	ПараметрыЗапуска.Вставить("РежимСинхронизации", "ОтправитьОдиночныйЗаказ");
	ПараметрыЗапуска.Вставить("ДатаНачалаСинхронизации", ТекущаяДата());
	ПараметрыЗапуска.Вставить("Данные", Заказ);

	Оповестить("НачатьСинхронизацию", ПараметрыЗапуска);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСинхронизациюПроверитьИсполнение()

	Результат = 
		ОбменВызовСервера.ПроверитьСостояниеФоновойСинхронизации(
			ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища, 
			ОписаниеПоследнегоОбновления);

	Оповестить("ВыполняетсяСинхронизация", Результат)

КонецПроцедуры

#КонецОбласти
