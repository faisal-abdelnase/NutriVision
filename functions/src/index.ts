export {
  bootstrapUser,
  completeOnboarding,
  updateNutritionProfile,
  updateUserPreferences,
} from "./features/account";

export {
  saveMeal,
  deleteMeal,
  getDashboardSummary,
} from "./features/meals";

export {
  saveProgressEntry,
  deleteProgressEntry,
  getProgressHistory,
} from "./features/progress";

export {
  analyzeMeal,
  sendCoachMessage,
  generateRecipe,
  saveGroceryItem,
  deleteGroceryItem,
} from "./features/ai";

export { deleteUserAccount } from "./features/account_lifecycle";
export {
  registerDeviceToken,
  scheduleMealReminder,
  sendScheduledReminders,
} from "./features/notifications";
export {
  setRecipeSaved,
  getSavedRecipes,
  getMealAnalysisHistory,
  getCoachConversationHistory,
  getProgressSummary,
  updateProfilePhotoPath,
} from "./features/queries";
