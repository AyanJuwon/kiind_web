import 'dart:ui';

Map<String, Map<String, Color>> categoriesColors = {
  'Aged': {'color': const Color(0xFFBFB811).withOpacity(0.4)},
  'Animals': {'color': const Color(0xFF168C86).withOpacity(0.4)},
  'Armed & Ex-Services': {'color': const Color(0xFFFF6B00).withOpacity(0.4)},
  'Children & Youth': {'color': const Color(0xFF60FB17).withOpacity(0.4)},
  'Community': {'color': const Color(0xFF417567).withOpacity(0.4)},
  'Culture & Heritage': {'color': const Color(0xFF1383EB).withOpacity(0.4)},
  'Disabilities': {'color': const Color(0xFF0E7B64).withOpacity(0.4)},
  'Education & Training': {'color': const Color(0xFF317F43).withOpacity(0.4)},
  'Employment, Trades & Professions': {
    'color': const Color(0xFFF80000).withOpacity(0.4)
  },
  'Environment': {'color': const Color(0xFF354D73).withOpacity(0.4)},
  'Family': {'color': const Color(0xFF6D6552).withOpacity(0.4)},
  'Health': {'color': const Color(0xFF1E2460).withOpacity(0.4)},
  'Housing': {'color': const Color(0xFFF3A505).withOpacity(0.4)},
  'Human Rights': {'color': const Color(0xFF2271B3).withOpacity(0.4)},
  'International': {'color': const Color(0xFFF39F18).withOpacity(0.4)},
  'Mental Health': {'color': const Color(0xFF287233).withOpacity(0.4)},
  'Overseas Aid': {'color': const Color(0xFFB32821).withOpacity(0.4)},
  'Religious': {'color': const Color(0xFFFF7514).withOpacity(0.4)},
  'Rescue Services': {'color': const Color(0xFFCF3476).withOpacity(0.4)},
  'Social Welfare & Equality': {
    'color': const Color(0xFF4E3B31).withOpacity(0.4)
  },
  'Sports & Recreation': {'color': const Color(0xFF7FB5B5).withOpacity(0.4)}
};

Map<String, List<String>> categories = {
  'Aged': [
    'Assisted Living for the Elderly',
    'Elderly Care & Welfare',
    'Illness in the Elderly',
    'Independent Living'
  ],
  'Animals': [
    'Animal Rescue, Centres & Homes',
    'Assistance Dogs',
    'Endangered Animals & Wildlife Conservation',
    'Pets',
    'Working Animals'
  ],
  'Armed & Ex-Services': [
    'Army',
    'Ex-Services',
    'Navy/Merchant Navy',
    'Royal Air Forces (RAF)'
  ],
  'Children & Youth': [
    'Child Protection',
    'Clubs & Associations',
    'Disabled',
    'Education & Training',
    'Health',
    'Holidays & Recreation',
    'Overseas',
    'Social Care'
  ],
  'Community': [
    'Counselling & Support',
    'Education & Training',
    'Homelessness',
    'Local Community',
    'Supported Living'
  ],
  'Culture & Heritage': [
    'Historic & Religious Buildings',
    'Museums',
    'The Arts',
    'Urban or Rural Conservation'
  ],
  'Disabilities': [
    'Education & Learning',
    'Employment',
    'Hearing Impairments',
    'Holidays & Respite Care',
    'Independent Living',
    'Learning Disabilities',
    'Sports',
    'Supported Living',
    'Visual Impairments'
  ],
  'Education & Training': [
    'Academies & Further Education',
    'Apprenticeships & Vocational Training',
    'Higher Education',
    'Independent Schools',
    'Special Educational Needs'
  ],
  'Employment, Trades & Professions': [
    'Apprenticeships',
    'Counselling & Support',
    'Disabled/Injured',
    'Employment',
    'Financial Support',
    'Professional/Trade Support Groups',
    'Retired'
  ],
  'Environment': [
    'Botanical Conservation',
    'Climate Change',
    'International',
    'Wildlife Conservation'
  ],
  'Family': [
    'Adoption & Fostering',
    'Bereavement',
    'Care for Carers',
    'Counselling & Support',
    'Domestic Abuse',
    'Financial Support',
    'Poverty',
    'Social Services'
  ],
  'Health': [
    "Braille & Audio for Visual Impairments",
    "Cancer",
    "Children's Health",
    "Disabled",
    "Drug Research",
    "Eye Infections & Diseases",
    "Heart Conditions",
    "Hearing Impairme",
    "Medical Research",
    "Mental Health",
    "Non-Terminal Disease",
    "Nursing & Carers",
    "Specific Conditions",
    "Stroke",
    "Visual Impairments Research"
  ],
  'Housing': [
    'Almshouses',
    'Elderly',
    'Homeless',
    'Rehabilitation',
    'Shelters',
    'Social Welfare',
    'Supported Living'
  ],
  'Human Rights': [
    'Abuse',
    'Counselling & Support',
    'Family',
    'Legal Advice',
    'Lesbian, Gay, Bisexual & Transgender',
    'Minority Groups',
    'Poverty',
    'Refugees',
    'Rehabilitation'
  ],
  'International': [
    'Africa',
    'Americas',
    'Asia',
    'Australasia',
    'Development',
    'Europe',
    'Global',
    'Middle East'
  ],
  'Mental Health': [
    'Counselling & Support',
    'Research',
    'Support for Carers',
    'Treatment',
    'Understanding & Awareness'
  ],
  'Overseas Aid': [
    'Children Overseas',
    'Development',
    'Disability',
    'Education',
    'Emergency Relief',
    'Health',
    'Social Welfare'
  ],
  'Religious': [
    'Buddhism',
    'Christian',
    'Hinduism',
    'Islam',
    'Judaism',
    'Sikhism'
  ],
  'Rescue Services': ['International', 'Search & Rescue'],
  'Social Welfare & Equality': [
    'Abuse',
    'Addiction',
    'Counselling & Support',
    'Family',
    'Financial Support',
    'Minority Groups',
    'Poverty',
    'Refugees',
    'Rehabilitation'
  ],
  'Sports & Recreation': [
    'Children',
    'Clubs & Associations for the Young',
    'Disabled',
    'Facilities & Equipment',
    'Holidays & Respite Care',
    'Scouts & Guides'
  ]
};
