int calculateRisk(List<String> symptoms) {
  int riskScore = symptoms.length;

  if (riskScore >= 4) {
    return 3; // High Risk
  } else if (riskScore == 2 || riskScore == 3) {
    return 2; // Medium Risk
  } else if (riskScore == 1) {
    return 1; // Low Risk
  } else {
    return 0; // No Risk
  }
}

String getRiskMessage(int riskLevel) {
  switch (riskLevel) {
    case 3:
      return "⚠️ High Risk: Consult a doctor immediately.";
    case 2:
      return "⚠️ Medium Risk: Monitor symptoms and stay hydrated.";
    case 1:
      return "✔️ Low Risk: Take rest and drink fluids.";
    default:
      return "✔️ No Risk: You are safe.";
  }
}
