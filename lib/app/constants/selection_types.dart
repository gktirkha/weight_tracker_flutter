enum SelectionTypes {
  weekly,
  monthly,
  yearly,
  monthlyAverage,
  yearlyAverage,
  all,
}

extension SelectionTypesX on SelectionTypes {
  static String label(SelectionTypes type) => switch (type) {
    SelectionTypes.weekly => 'Weekly',

    SelectionTypes.monthly => 'Monthly',

    SelectionTypes.yearly => 'Yearly',

    SelectionTypes.monthlyAverage => 'Monthly Average',

    SelectionTypes.yearlyAverage => 'Yearly Average',

    SelectionTypes.all => 'All',
  };
}
