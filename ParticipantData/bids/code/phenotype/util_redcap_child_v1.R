#' util_redcap_child1: Organize child visit 1 data from REDCap (called within proc_redcap.R)
#'
#' This function organizes REDCap data from REDCap visit data, event child_visit_1_arm_1
#'
#'
#' @param data data from REDCap event child_visit_1_arm_1
#' @inheritParams util_redcap_prepost1
#'
#' @return If return_data is set to TRUE, will return a list including:
#'  1) clean raw child visit 1 datasets
#'  2) meta-data/.json for each dataset
#'
#' @examples
#'
#' # process REDCap data
#' child_visit1_data <- util_redcap_child1_org(data)
#'
#' \dontrun{
#' }
#'
#'
#' @export

# for testing


util_redcap_child1 <- function(data, return_data = TRUE) {
  
  #### 1. Set up/initial checks #####
  
  # check that data exist and is a data.frame
  data_arg <- methods::hasArg(data)
  
  if (isTRUE(data_arg)) {
    if (!is.data.frame(data)) {
      stop("data must be a data.frame")
    } 
  } else if (isFALSE(data_arg)) {
    stop("child data for REDCap event child_visit_1_arm_1 must be entered as a data.frame")
  }
  
  #reduce columns and update names
  
  # ## demo ####
  # child_v1demo_data <- data[c('record_id', 'v1_general_notes', 'relationship', 'c_height1_cm', 'c_height2_cm', 'c_weight1_kg', 'c_weight2_kg', 'c_height_avg_cm', 'c_weight_avg_kg', 'c_bmi', 'c_bmi_pcent', 'c_weightstatus', 'p_height1_cm', 'p_height2_cm', 'p_weight1_kg', 'p_weight2_kg', 'p_height_avg_cm', 'p_weight_avg_kg', 'p_bmi', 'p_weightstatus', 'heightweight_notes')]
  # 
  # names(child_v1demo_data)[1] <- 'participant_id'
  # 
  # ## household ####
  # child_household_data <- data[c('record_id', 'p_height1_cm', 'p_height2_cm', 'p_weight1_kg', 'p_weight2_kg', 'p_height_avg_cm', 'p_weight_avg_kg', 'p_bmi', 'p_weightstatus', 'heightweight_notes')]
  # 
  # names(child_household_data)[1] <- 'participant_id'
  # 
  # ## meal information ####
  # meal_info <- data[c('record_id', 'pre_liking_ff_time', 'pre_liking_ff_notes', 'vas_mac', 'vas_cknug', 'vas_grapes', 'vas_carrot', 'vas_water', 'pre_meal_ff_time', 'pre_meal_ff_notes', 'test_meal_book', 'test_meal_start_time', 'test_meal_end_time', 'test_meal_duration', 'test_meal_notes', 'post_meal_ff_time', 'toolbox_list_sorting_notes', 'pre_wanting_ff_time', 'pre_wanting_ff_notes', 'eah_liking_and_wanting_timestamp', 'vas_popcorn', 'want_popcorn', 'vas_pretzel', 'want_pretzel', 'vas_cornchip', 'want_cornchip', 'vas_cookie', 'want_cookie', 'vas_brownie', 'want_brownie', 'vas_starburst', 'want_starburst', 'vas_skittle', 'want_skittle', 'vas_chocolate', 'want_chocolate', 'vas_icecream', 'want_icecream', 'vas_eah_want_notes', 'eah_game_wanting_timestamp', 'want_markers', 'want_crayons', 'want_color_marvels', 'want_oonies_inflate', 'want_colorpencils', 'wan_activitybook', 'want_colorbook', 'want_legos', 'want_squeakee', 'want_dinosaurs', 'want_oonies', 'eah_game_wanting_notes', 'pre_eah_freddy_time', 'eah_start_time', 'eah_end_time', 'eah_notes', 'post_eah_ff_time', 'post_eah_ff_notes')]
  # 
  # names(meal_info)[c(1, 11:15, 17:20, 39:40, 52, 54:55)] <- c('participant_id', 'meal_book', 'meal_start', 'meal_end', 'meal_duration', 'meal_notes', 'nih_listsort_notes', 'pre_want_ff_time', 'pre_want_ff_notes', 'eah_likewant_time', 'eah_likewant_notes', 'eah_game_want_time', 'eah_game_want_notes', 'eah_start', 'eah_end')
  # 
  # names(meal_info)[1] <- 'participant_id'
  # 
  ## kids brand awareness survey ####
  
  # ## HFI data
  # hfi_data <- data[, grepl('record_id', names(data)) | grepl('hfi', names(data))] 
  # hfi_data <- hfi_data[, !grepl('qcheck', names(hfi_data))]
  # names(hfi_data)[1] <- 'participant_id'
  # 
  # names(hfi_data) <- gsub('___', '', names(hfi_data))
  # names(hfi_data) <- gsub('visible', 'accesible', names(hfi_data))
  # 
  # #hfi_scored <- dataprepr::score_hfi(hfi_data, id = 'participant_id', score_base = TRUE)
  # hfi_scored <- score_hfi(hfi_data, id = 'participant_id', score_base = TRUE)
  # hfi_json <- json_hfi()
  
  if (isTRUE(return_data)){
    return(list(
      demo_data = list(child_v1demo_data = child_v1demo_data, 
                       child_household_data = child_household_data),
      otherdata = list(task_info = task_info, 
                       meal_info = meal_info),
      hfi_data = list(data = hfi_scored, meta = hfi_json)))
  }
}

